#include <stdio.h>
#include <pcap.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <string.h>
#include <netinet/ether.h>
#include <netinet/ip6.h>
#include <netinet/ip.h>
#include <netinet/tcp.h>
#include <netinet/udp.h>
#include <openssl/sha.h>


#define DISPLAY_TIMEOUT 400
#define TCP_EXT_HEADER 6
#define UDP_EXT_HEADER 17
#define NO_NXT_IP6 59

typedef struct flow_packet flow_packet;
typedef struct node node;

typedef struct packet{
    char * src_ip;
    char * dst_ip;

    uint16_t src_prt;
    uint16_t dst_prt;

    int header_len;
    int payload_len;
    int retrans;

    char * protocol;
}packet_t;

struct flow_packet{
    char src_ip[INET6_ADDRSTRLEN];
    char dst_ip[INET6_ADDRSTRLEN];

    uint16_t src_prt;
    uint16_t dst_prt;

    char protocol[4];
};

struct node{
    flow_packet * packet;
    node * next;
};



void packet_handler(u_char *, const struct pcap_pkthdr *, const u_char *);
void setup_nif(const char *);
void parse_pcap(const char *);
void exit_parsing(void);
void start_loop(pcap_t *, int, pcap_handler, u_char *);
void print_packet(packet_t *);
void handle_tcp_header(const struct tcphdr*, packet_t *, int);
void handle_udp_header(const struct udphdr*, packet_t *, int);
void usage(void);
void print_hex(unsigned char *, size_t);
void add_node(node **, flow_packet *);
int exists(node *, flow_packet *);
flow_packet * craft_flow_packet(packet_t *, int);
void cleanup(void);


int net_flows = 0;
int tcp_net_flows = 0;
int udp_net_flows = 0;
int packets_total = 0;
int tcp_packs_recv = 0;
int udp_packs_recv = 0;
int tcp_bytes_recv = 0;
int udp_bytes_recv = 0;
node * head = NULL;

int main(int argc, char ** argv) {
    /* Ctrl + C stops the program displaying the exit messages */

    fclose(fopen("capture", "w"));
    struct sigaction sa;
    sa.sa_handler = (__sighandler_t) exit_parsing;
    sa.sa_flags = 0;
    sigemptyset(&sa.sa_mask);
    sigaction(SIGINT, &sa, NULL);
    sigaction(SIGTERM, &sa, NULL);
    sigaction(SIGQUIT, &sa, NULL);

    char ch;
    while ((ch = getopt(argc, argv, "hi:r:")) != -1) {
        switch (ch) {
            case 'i':
                setup_nif(optarg);
                break;
            case 'r':
                parse_pcap(optarg);
                break;
            case 'h':
                usage();
                break;
            default:
                usage();
        }
    }

    return 0;
}

void setup_nif(const char * nif){
    /**
     * Define error buffer and pcap handle
     */
    char errbuf[PCAP_ERRBUF_SIZE];
    pcap_t * handle;

    /*
     * Try to open device
     */
    if((handle = pcap_open_live(nif, BUFSIZ, 0, DISPLAY_TIMEOUT, errbuf)) == NULL){
        fprintf(stderr, "Could not open device %s\n", errbuf);
        exit(EXIT_FAILURE);
    }

    start_loop(handle, 0, packet_handler, NULL);
}

void parse_pcap(const char * dump){
    char errbuf[PCAP_ERRBUF_SIZE];
    pcap_t * handle;

    /*
     * Try to open capture file
     */
    if((handle = pcap_open_offline(dump, errbuf)) == NULL){
        fprintf(stderr, "Could not open capture file %s\n", errbuf);
        exit(EXIT_FAILURE);
    }

    start_loop(handle, 0, packet_handler, NULL);

    exit_parsing();
}

void start_loop(pcap_t * handle, int cnt, pcap_handler packet_handler, u_char * user){
    /* start the loop with handle and exit if error */
    if(pcap_loop(handle, cnt, packet_handler, user) == PCAP_ERROR){
        pcap_perror(handle, "PCAP LOOP failed: ");
        exit(EXIT_FAILURE);
    }
}

void packet_handler(u_char * args, const struct pcap_pkthdr * header, const u_char * packet){
    /* captured packet */
    packets_total++;

    char source_IP[INET_ADDRSTRLEN] = {0};
    char dest_IP[INET_ADDRSTRLEN] = {0};
    char source_IP6[INET6_ADDRSTRLEN] = {0};
    char dest_IP6[INET6_ADDRSTRLEN] = {0};

    packet_t packet_s;
    uint8_t next_header;
    int payload_len;
    int header_len;

    const struct ether_header * eth_header;
    const struct ip * ip_header;
    const struct ip6_hdr * ip_6_header;
    const struct tcphdr * tcp_header;
    const struct udphdr * udp_header;
    struct ip6_ext * ext_header;

    uint16_t etherType;

    /* check if it is an ipv4/6 packet exit if not */
    eth_header = (struct ether_header *)packet;
    etherType = ntohs(eth_header->ether_type);

    if(etherType == ETHERTYPE_IP) {
        /* IP HEADER */
        /* get the ipv4 header */
        ip_header = (struct ip *) (packet + sizeof(struct ether_header));
        inet_ntop(AF_INET, &(ip_header->ip_src), source_IP, INET_ADDRSTRLEN);
        inet_ntop(AF_INET, &(ip_header->ip_dst), dest_IP, INET_ADDRSTRLEN);

        /* HEADER length is 4 * ip_hl */
        header_len = 4 * ip_header->ip_hl;
        /* find the payload */
        payload_len = ntohs(ip_header->ip_len) - header_len;

        /* grab IPs */
        packet_s.src_ip = source_IP;
        packet_s.dst_ip = dest_IP;
        /* PAYLOAD SECTION */
        if (ip_header->ip_p == IPPROTO_TCP) {
            /* TCP PACKET */
            /* global stats */
            tcp_bytes_recv += payload_len;
            packet_s.payload_len = payload_len;
            tcp_header = (struct tcphdr *) (packet + sizeof(struct ether_header) + sizeof(struct ip));
            /* handle the tcp packet */
            handle_tcp_header(tcp_header, &packet_s, 0);
        } else if (ip_header->ip_p == IPPROTO_UDP) {
            /* UDP PACKET */
            /* global stats */
            udp_header = (struct udphdr *) (packet + sizeof(struct ether_header) + sizeof(struct ip));
            /* can get the payload from the header it self */
            udp_bytes_recv += ntohs(udp_header->len);
            handle_udp_header(udp_header, &packet_s, 0);
        }
    }else if(etherType == ETHERTYPE_IPV6){
        ip_6_header = (struct ip6_hdr *) (packet + sizeof(struct ether_header));
        inet_ntop(AF_INET6, &(ip_6_header->ip6_src), source_IP6, INET6_ADDRSTRLEN);
        inet_ntop(AF_INET6, &(ip_6_header->ip6_dst), dest_IP6, INET6_ADDRSTRLEN);

        /* grab payload and IPs */
        packet_s.payload_len = ntohs(ip_6_header->ip6_ctlun.ip6_un1.ip6_un1_plen);
        packet_s.src_ip = source_IP6;
        packet_s.dst_ip = dest_IP6;

        /* get next header */
        next_header = ip_6_header->ip6_ctlun.ip6_un1.ip6_un1_nxt;

        /* exit if no header is found */
        if(next_header == NO_NXT_IP6){
            return;
        }
        /* advance to the next header, HOP */
        ext_header = (struct ip6_ext *)(packet + sizeof(struct ether_header) + sizeof(struct ip6_hdr));

        /* loop thgough the headers untill TCP / UDP / no header is found */
        while(1){
            if(next_header == TCP_EXT_HEADER || next_header == UDP_EXT_HEADER || next_header == NO_NXT_IP6){
                break;
            }
            /* subtract the header length to get tcp/udp length */
            packet_s.payload_len -= ntohs(ext_header->ip6e_len);
            next_header = ext_header->ip6e_nxt;
            ext_header += ext_header->ip6e_len;
        }

        if(next_header == TCP_EXT_HEADER){
            tcp_header = (struct tcphdr *)ext_header;
            tcp_bytes_recv += packet_s.payload_len;
            handle_tcp_header(tcp_header, &packet_s, 1);
        }else if(next_header == UDP_EXT_HEADER){
            udp_header = (struct udphdr *)ext_header;
            udp_bytes_recv += packet_s.payload_len;
            packet_s.payload_len = ntohs(udp_header->len);
            handle_udp_header(udp_header, &packet_s, 1);
        }else{
            return;
        }
    }
}

void handle_tcp_header(const struct tcphdr * tcp_header, packet_t * packet_s, int ipv6){
    uint16_t source_port;
    uint16_t dest_port;
    char protocol[4];
    flow_packet * packet;

    tcp_packs_recv++;

    /* grab ports */
    source_port = ntohs(tcp_header->th_sport);
    dest_port = ntohs(tcp_header->th_dport);
    /* copy protocol */
    strncpy(protocol, "TCP\0", 4);
    packet_s->src_prt = source_port;
    packet_s->dst_prt = dest_port;
    packet_s->protocol = protocol;
    /* subtract the header length */
    packet_s->payload_len -= tcp_header->doff*4;
    packet_s->header_len = tcp_header->doff*4;
    packet_s->retrans = 0;

    /* craft the flow packet */
    packet = craft_flow_packet(packet_s, ipv6);

    /* check if flow exists */
    if(!exists(head, packet)){
        net_flows++;
        tcp_net_flows++;
        add_node(&head, packet);
    }else{
        free(packet);
    }

    /* print the packet */
    print_packet(packet_s);
}

void handle_udp_header(const struct udphdr * udp_header, packet_t * packet_s, int ipv6){
    flow_packet * packet;
    uint16_t source_port;
    uint16_t dest_port;
    char protocol[4];

    udp_packs_recv++;

    source_port = ntohs(udp_header->uh_sport);
    dest_port = ntohs(udp_header->uh_dport);
    strncpy(protocol, "UDP\0", 4);
    packet_s->src_prt = source_port;
    packet_s->dst_prt = dest_port;
    packet_s->protocol = protocol;
    packet_s->payload_len = ntohs(udp_header->len) - 8;
    packet_s->retrans = 0;
    packet_s->header_len = 8;

    packet = craft_flow_packet(packet_s, ipv6);

    if(!exists(head, packet)){
        net_flows++;
        udp_net_flows++;
        add_node(&head, packet);
    }else{
        free(packet);
    }

    print_packet(packet_s);
}

void usage(void) {
    printf("./monitor -r [dump.pcap] | -i [network interface]\n"
           "Options:\n"
           "-r  Process Pactes from dump.pcap\n"
           "-i  Process Packets from network interfate\n"
           "-h  This help message\n");
}

void exit_parsing(void){
    printf("----------------EXIT----------------\n"
           "Total network flows captured: %d\n"
           "TCP network flows: %d\n"
           "UDP network flows: %d\n"
           "Total packets received: %d\n"
           "TCP packets received: %d\n"
           "UDP packets received: %d\n"
           "Total TCP bytes received: %d\n"
           "Total UDP bytes received: %d\n"
           "----------------EXIT----------------\n",
            net_flows,
            tcp_net_flows,
            udp_net_flows,
            packets_total,
            tcp_packs_recv,
            udp_packs_recv,
            tcp_bytes_recv,
            udp_bytes_recv);
    cleanup();
    exit(EXIT_SUCCESS);
}

void print_packet(packet_t * packet){
    FILE * fp = fopen("capture", "a");
    fprintf(fp,"-------------------PACKET-------------------\n"
           "| SOURCE IP: %s\tPORT: %d\n"
           "| DEST IP:  %s\tPORT: %d\n"
           "| PROTOCOL: %s\n"
           "| HEADER SIZE: %d\n"
           "| PAYLOAD SIZE: %d\n"
           "| RETRASMITTED: %s\n",
           packet->src_ip, packet->src_prt,
           packet->dst_ip, packet->dst_prt,
           packet->protocol,
           packet->header_len,
           packet->payload_len,
           (packet->retrans)?"Y":"N");
    fprintf(stdout,"-------------------PACKET-------------------\n"
               "| SOURCE IP: %s\tPORT: %d\n"
               "| DEST IP:  %s\tPORT: %d\n"
               "| PROTOCOL: %s\n"
               "| HEADER SIZE: %d\n"
               "| PAYLOAD SIZE: %d\n"
               "| RETRASMITTED: %s\n",
            packet->src_ip, packet->src_prt,
            packet->dst_ip, packet->dst_prt,
            packet->protocol,
            packet->header_len,
            packet->payload_len,
            (packet->retrans)?"Y":"N");
    fflush(fp);
    fclose(fp);
}

void print_hex(unsigned char *data, size_t len){
    size_t i;

    if (!data)
        printf("NULL data\n");
    else {
        for (i = 0; i < len; i++) {
            printf("%02X", data[i]);
        }
        printf("\n");
    }
}

flow_packet * craft_flow_packet(packet_t * packet, int ipv6){
    flow_packet * flow = (flow_packet *)malloc(sizeof(flow_packet));

    memset(flow->src_ip, 0, INET6_ADDRSTRLEN);
    memset(flow->dst_ip, 0, INET6_ADDRSTRLEN);

    if(ipv6){
        memcpy(flow->src_ip, packet->src_ip, INET6_ADDRSTRLEN);
        memcpy(flow->dst_ip, packet->dst_ip, INET6_ADDRSTRLEN);
    }else{
        memcpy(flow->src_ip, packet->src_ip, INET_ADDRSTRLEN);
        memcpy(flow->dst_ip, packet->dst_ip, INET_ADDRSTRLEN);
    }
    flow->src_prt = packet->src_prt;
    flow->dst_prt = packet->dst_prt;

    memcpy(flow->protocol, packet->protocol, 4);

    return flow;
}

int check_flow(flow_packet * a, flow_packet * b){
    /**
     * check if flow exists
     * FLOW definition:
     * a:1 -> b:2 , tcp
     * b:2 -> a:1 , tcp
     * 1 flow
     * a:1 -> b:2 , tcp
     * a:2 -> b:2 , tcp
     * 2 flows
     */
    if((((!strcmp(a->src_ip, b->src_ip) && a->src_prt == b->src_prt) &&
        (!strcmp(a->dst_ip, b->dst_ip) && a->dst_prt == b->dst_prt))
    || ((!strcmp(a->src_ip, b->dst_ip) && a->src_prt == b->dst_prt) &&
        (!strcmp(a->dst_ip, b->src_ip) && a->dst_prt == b->src_prt)))
    && (!strncmp(a->protocol, b->protocol, 4)))
        {
        return 1;
    }else{
        return 0;
    }
}

int exists(node * head_arg, flow_packet * packet){
    /* go through the list break if found */
    node * tmp = head_arg;
    if(head_arg == NULL){
        return 0;
    }
    while(tmp != NULL){
        if(check_flow(tmp->packet, packet)){
            return 1;
        }
        tmp = tmp->next;
    }
    return 0;
}

void add_node(node ** head_arg, flow_packet * packet){
    /* basic linked list prepenting*/
    node * new = (node *)malloc(sizeof(node));
    new->packet = packet;
    new->next = (*head_arg);
    (*head_arg) = new;
}

void cleanup(void){
    /* clean up*/
    node * tmp = head;
    while(head != NULL){
        tmp = tmp->next;
        free(head->packet);
        free(head);
        head = tmp;
    }
}
