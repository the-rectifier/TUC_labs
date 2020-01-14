#include <string.h>
#include <sys/socket.h>
#include <stdio.h>
#include <stdlib.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <signal.h>
#include <netdb.h>

#define OUTSNIPPET "output.receive."
//#define HOST "127.0.0.1"
//#define HOST "172.16.1.12"
//#define TCP_PORT 6666
//#define UDP_PORT 7777


int get_lines(FILE* fp)
{
    int lines = 1;
    char buff[11] = {0};
    char ch;
    int i=0;
    while ((ch = fgetc(fp)) != EOF)
    {
        if(i<11)
        {
            buff[i] = ch;
            i++;
        }
        if(strncmp(buff,"end",3)==0 || strncmp(buff,"timeToStop",10)==0)
        {
            lines--;
            memset(buff,0,11);
            i=0;
        }
        if (ch == '\n'){
            lines++;
            memset(buff,0,11);
            i=0;
        }
    }
    rewind(fp);
    return lines-1;
}

void perror_exit(char *msg, pid_t pid)
{
    perror(msg);
    // become KRONOS
    kill(pid, SIGKILL);
    exit(EXIT_FAILURE);
}

void read_send(FILE * fp, int tcp_sock, int udp_port)
{
    char port[10] = {0};
    char buff[300] = {0};
    sprintf(port,"%d",udp_port);
    strcpy(buff,port);
    int count = 0;
    char *line = NULL;
    size_t len = 0;
    size_t rsize = 0;
    size_t wsize = 0;
    while ((rsize = getline(&line, &len, fp)) != -1)
    {
        if(count == 10)
        {
            count = 0;
            puts("sleepin...zzz...zzz...");
            sleep(5);
        }
        // replace the darn LF with a null byte
        line[strlen(line)-1] ='\0';
        //printf("%d Line Read sized %d is %s\n",count, (int)rsize, buff);
        //sleep(1);
        strcpy(buff+10,line);
        wsize = write(tcp_sock, buff, 300);
        //printf("Wrote %d bytes to tcp_sock\n", (int)wsize);
        //sleep(1);
        count++;
        memset(buff+10, 0, sizeof(buff)-10);
    }
}

int main(int argc, char * argv[])
{
    if(argc > 5| argc <5)
    {
        puts("Usage: ./remoteClient server_hostname server_port client_listening_udp_port file");
        exit(EXIT_FAILURE);
    }
    struct sockaddr_in tcp_addr, udp_addr;
    struct sockaddr *tcp_ptr=(struct sockaddr *)&tcp_addr;
    struct sockaddr *udp_ptr=(struct sockaddr *)&udp_addr;
    struct hostent *rem;

    int udp_port = atoi(argv[3]);
    int tcp_port = atoi(argv[2]);
    char *hostname = argv[1];
    rem = gethostbyname(hostname);
    struct in_addr ** addr_list;
    addr_list = (struct in_addr **)rem->h_addr_list;
    char *ip = inet_ntoa(*addr_list[0]);
    //puts(ip);
    char udp_buffer[512] = {0};
    char out_num[10]={0};
    char out_file[30];
    FILE* fp = fopen(argv[4], "r");
    FILE* out;
    int count = 1;
    pid_t tcp_handler = getpid();
    pid_t udp_handler;
    int tcp_sock,udp_sock;
    int reuse = 1;
    int lines = get_lines(fp);
    //printf("%d\n", lines);
    size_t rsize;
    int len=0;
    udp_handler = fork();

    if(udp_handler == 0)
    {
        printf("UDP handler started with PID %d called by %d\n", getpid(), getppid());
        udp_sock = socket(AF_INET, SOCK_DGRAM, 0);
        if (udp_sock == -1)
        {
            perror_exit("UDP_socket creation failed\n", getppid());
        }
        else
        {
            printf("UDP_Socket successfully created\n");
        }
        udp_addr.sin_family = AF_INET;
        udp_addr.sin_addr.s_addr = htonl(INADDR_ANY);
        udp_addr.sin_port = htons(udp_port);
        if(setsockopt(udp_sock, SOL_SOCKET, SO_REUSEADDR,(const char*)&reuse, sizeof(reuse)) < 0)
        {
            perror_exit("Error setting socket reusable", getppid());
        }
        if(bind(udp_sock, udp_ptr, sizeof(udp_addr)) < 0)
        {
            perror_exit("Error binding to udp port\n", getppid());
        }
////////////////////edit this when time
        puts("Waiting for udp pckgs");
        while(1)
        {
            sprintf(out_num, "%d", count);
            strcpy(out_file, OUTSNIPPET);
            strcat(out_file,out_num);
            out = fopen(out_file,"w");
            while(1)
            {
                recvfrom(udp_sock, udp_buffer, 512, 0, udp_ptr, (unsigned int *)&len);
                if (strncmp(udp_buffer, "DONE", 4) == 0)
                {
                    //puts("DONE");
                    memset(udp_buffer, 0, sizeof(udp_buffer));
                    break;
                }
                else if (strncmp(udp_buffer, "bad", 3) == 0)
                {
                    //puts("BAD");
                    memset(udp_buffer, 0, sizeof(udp_buffer));
                    break;
                }
                else
                {
                    fprintf(out, "%s", udp_buffer);
                    memset(udp_buffer,0,sizeof(udp_buffer));
                }
            }
            fclose(out);
            if(lines==count){break;}
            //printf("%d %d\n", count, lines);
            count++;
            memset(udp_buffer,0,sizeof(udp_buffer));
        }
        exit(EXIT_SUCCESS);
////////////////////////////////////////////////////////////////////////////////// this
    }
    else if(udp_handler < 0)
    {
        perror_exit("Could not start udp handler\n", tcp_handler);
    }
    else
    {
        printf("TCP handler Process: %d\n", tcp_handler);
        tcp_sock = socket(AF_INET, SOCK_STREAM, 0);
        if (tcp_sock == -1)
        {
            perror_exit("TCP_socket creation failed\n",udp_handler);
        }
        else
        {
            printf("TCP_Socket successfully created\n");
        }

        tcp_addr.sin_family = AF_INET;
        tcp_addr.sin_addr.s_addr = inet_addr(ip);
        tcp_addr.sin_port = htons(tcp_port);
        printf("Server: %s:%d\n",inet_ntoa(tcp_addr.sin_addr),ntohs(tcp_addr.sin_port));
        // connect the client socket to server socket
        if (connect(tcp_sock, tcp_ptr, sizeof(tcp_addr)) != 0)
        {
            perror_exit("TCP connection with the server failed\n", udp_handler);
        }
        else
        {
            printf("Connected to the TCP server\n");
        }
        read_send(fp, tcp_sock, udp_port);
        close(tcp_sock);
    }
    wait(NULL);
    return 0;
}