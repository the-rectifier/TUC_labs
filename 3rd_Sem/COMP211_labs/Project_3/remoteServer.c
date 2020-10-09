#include <string.h>
#include <sys/socket.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/select.h>
#include <unistd.h>
#include <signal.h>

#define READ 0
#define WRITE 1
//#define CHILDREN 3
//#define UDP_PORT 8888
//#define PORT 6666
int socket_init(int , int , struct sockaddr_in *);
void perror_exit(char *);
void child_server(int);
char *parse(char *);
void suicide(int);
void kronos(int);
void wait_for_ded(int);
bool valid(char *);

int main(int argc, char * argv[])
{
    static struct sigaction act;


    if (argc < 3 || argc > 3)
    {
        puts("Usage: ./remoteServer PORT #_of_children");
        exit(EXIT_FAILURE);
    }


    //int port = 6666;
    struct sockaddr_in tcp_addr;
    struct sockaddr_in client_sock;
    struct sockaddr_in tcp_client;
    struct sockaddr_in * client_ptr = (struct sockaddr_in *)&client_sock;
    int client_len = sizeof(client_sock);

    int confd;
    int tcp_socket;
    int p_fd[2];
    char buff[300]={0};
    char child_buff[300]={0};
    char temp_port[10]={0};
    char ip[20]={0};
    size_t rsize;
    pid_t child_pid;
    pid_t parent_pid = getpid();

    //printf("Parent process started PID: %d\n", parent_pid);
    if (pipe(p_fd) < 0)
    {
        perror_exit("Error creating pipe");
    }
    //fcntl(p_fd[READ], F_SETFL,O_NONBLOCK);
    signal(SIGPIPE, SIG_IGN);
    for (int i = 0; i < atoi(argv[2]); i++)
    {

        child_pid = fork();
        signal(SIGUSR2, suicide);
        if (child_pid == 0)
        {
            puts("Child waiting for data");
            child_server(p_fd[READ]);
        } else if (child_pid < 0)
        {
            perror_exit("Error forking");
        }
    }
//Parent goes here
    act.sa_handler = kronos;
    sigemptyset(&(act.sa_mask));
    act.sa_flags = SA_RESTART;
    sigaction(SIGUSR1, &act, NULL);
    sigaction(SIGUSR2, &act, NULL);

    fd_set activefd_set, readfd_set;
    size_t wsize;
    tcp_socket = socket_init(atoi(argv[1]), SOCK_STREAM, &tcp_addr);
    char hostbuffer[256];
    gethostname(hostbuffer, sizeof(hostbuffer));
    //host_entry = gethostname(hostbuffer);
    printf("Hostname: %s\nListening on port: %s\n",hostbuffer, argv[1]);

    //signal(SIGUSR2, kronos);

    if ((listen(tcp_socket, 5)) != 0)
    {
        perror_exit("Cant start listening");
    } else
    {
        printf("TCP Server listening..\n");
    }

    FD_ZERO(&activefd_set);
    FD_SET(tcp_socket, &activefd_set);

    while(1)
    {
        readfd_set = activefd_set;
        if (select(FD_SETSIZE, &readfd_set, NULL, NULL, NULL) < 0)
        {
            perror_exit("Error selecting ");
        }
        for (int i = 0; i < FD_SETSIZE; i++)
        {
            //printf("FD_SIZE = %d",FD_SETSIZE);
            if (FD_ISSET(i, &readfd_set))
            {
                if (i == tcp_socket)
                {
                    confd = accept(tcp_socket, (struct sockaddr *) &client_sock, (unsigned int *)&client_len);
                    if (confd < 0)
                    {
                        perror_exit("TCP Server acccept failed");
                    } else
                    {
                        //puts("TCP Server acccept the client");
                    }
                    printf("Got connection From: %s:%d fd:(%d)\n", inet_ntoa(client_sock.sin_addr),ntohs(client_sock.sin_port), confd);
                    FD_SET(confd, &activefd_set);
                } else
                {
                    confd = i;
                    /*
                    if(getpeername(confd,(struct sockaddr *)client_ptr, (socklen_t *)&client_len) < 0)
                    {
                        perror_exit("Could not get Peer name");
                    }
                     */
                    //puts(client_ip);
                    rsize = read(confd, buff, sizeof(buff));
                    if (rsize <= 0)
                    {
                        printf("Client %d disconnected\n", confd);
                        close(confd);
                        FD_CLR(confd, &activefd_set);
                        break;
                    }
                    strncpy(temp_port,buff,10);
                    if(strlen(buff+10)==0)
                    {
                        break;
                    }
                    strcpy(buff,parse(buff+10));
                    //printf("Parsed command is %s\n", buff);
                    strcpy(ip,inet_ntoa(client_sock.sin_addr));
                    //printf("Read %d bytes from client: %s\n", rsize, parsed);
                    //printf("Im gonna write this into the PIPE: %s %s %s\n",ip,temp_port,buff);
                    strncpy(child_buff,ip, 20);
                    strncpy(child_buff +20,temp_port,10);
                    strncpy(child_buff+30,buff, 270);
                    wsize = write(p_fd[WRITE],child_buff, sizeof(child_buff));
                    //printf("Wrote %d to pipe for ma kid\n", (int)wsize);
                    //RESET rEsEt ReSet!!!
                    memset(buff, 0, sizeof(buff));
                    memset(child_buff, 0, sizeof(child_buff));
                    memset(temp_port,0, sizeof(temp_port));
                    memset(ip,0, sizeof(ip));
                    //i = 1024;
                    sleep(1);
                }
            }
        }
    }
}

void perror_exit(char *msg)
{
    perror(msg);
    // become KRONOS
    kill(-getpid(), SIGUSR2);
    wait_for_ded(SIGUSR2);
    exit(EXIT_FAILURE);
}

int socket_init(int port, int type, struct sockaddr_in *sockaddress)
{
    struct sockaddr * sockaddress_ptr=(struct sockaddr *)sockaddress;

    int sock;
    int reuse = 1;
    sock = socket(AF_INET, type, 0);
    if (sock == -1)
    {
        perror_exit("Socket creation failed\n");
    }
    else
    {
        //printf("%d Socket successfully created\n", type);
    }

    (*sockaddress).sin_family = AF_INET;
    (*sockaddress).sin_addr.s_addr = htons(INADDR_ANY);
    (*sockaddress).sin_port = htons(port);

    if(setsockopt(sock, SOL_SOCKET, SO_REUSEADDR,(const char*)&reuse, sizeof(reuse)) < 0)
    {
        perror("Error setting socket reusable");
    }
    if (bind(sock, sockaddress_ptr, sizeof((*sockaddress))) != 0)
    {
        perror_exit("socket bind failed...");
    }
    else
    {
        //printf("%d Socket successfully binded..\n", type);
    }
    return sock;
}

void child_server(int p_fd)
{
    FILE *out;
    //char *daddy_ded = "deadServer";
    char *done_with_file = "DONE";
    char pid[10] = {0};
    sprintf(pid,"%d", getpid());
    char *bad = "bad";
    int udp_socket;
    struct sockaddr_in udp_addr;
    udp_socket = socket(AF_INET,SOCK_DGRAM,0);
    udp_addr.sin_family = AF_INET;
    //printf("pid %d socket %d\n",getpid(), udp_socket);
    char port[10] = {0};
    char ip[20] = {0};
    char buff[300] = {0};
    char child_buffer[300] = {0};
    size_t rsize;
    while(1)
    {
        sleep(2);
        rsize = read(p_fd, child_buffer, sizeof(child_buffer));
        //printf("Child with PID: %d and PPID: %d\n",getpid(),getppid());
        strncpy(ip,child_buffer,20);
        //puts(ip);
        strncpy(port,child_buffer+20,10);
        //puts(port);
        strncpy(buff,child_buffer+30,270);
        //printf("i sent this %s to %s:%s\n", buff,ip,port);
        udp_addr.sin_addr.s_addr = inet_addr(ip);
        udp_addr.sin_port=htons(atoi(port));
        if(strncmp(buff,"bad",3)==0)
        {
            //puts("bad command");
            int send_size = sendto(udp_socket,bad,strlen(bad), 0, (const struct sockaddr *)&udp_addr, sizeof(udp_addr));
            //printf("%d\n", send_size);
            memset(buff, 0, sizeof(buff));
        }
        else if(strncmp(buff,"end",3)==0)
        {
            printf("Im dying %d\n", getpid());
            kill(getppid(),SIGUSR1);
            close(p_fd);
            fprintf(stderr,"%s\n",pid);
            suicide(SIGUSR1);
        }
        else if(strncmp(buff,"timeToStop",10)==0)
        {
            //puts("Stap");
            close(p_fd);
            fprintf(stderr,"%s\n",pid);
            kill(getppid(), SIGUSR2);
        }
        else if(strlen(buff)!= 0)
        {
            udp_addr.sin_addr.s_addr = inet_addr(ip);
            udp_addr.sin_port=htons(atoi(port));
            out = popen(buff,"r");
            while(fgets(buff,sizeof(buff),out) != NULL)
            {
                int send_size = sendto(udp_socket,buff, sizeof(buff), 0, (const struct sockaddr *)&udp_addr, sizeof(udp_addr));
                memset(buff, 0, sizeof(buff));
            }
            int send_size = sendto(udp_socket,done_with_file, 512, 0, (const struct sockaddr *)&udp_addr, sizeof(udp_addr));
            //memset(buff, 0, sizeof(buff));
            fclose(out);
            //sleep(1);
        }
        memset(buff, 0, sizeof(buff));
        memset(child_buffer,0, sizeof(child_buffer));
        sleep(1);
    }
}

char *parse(char* str)
{
    char *invalid_cmd = "bad";
    char *end = "end";
    char *timeToStop = "timeToStop";
    char tmp[120] ={0};
    if(strlen(str) > 100)
    {
        return strdup(invalid_cmd);
    }
    strcpy(tmp,str);
    str = tmp;
    bool first = true;
    int i=0;
    char command[100] = {0};
    int index=0;
    /* Find last index of whitespace character */
    while(str[index] == ' ' || str[index] == '\t')
    {
        index++;
    }
    if(index != 0)
    {
        /* Shift all trailing characters to its left */
        i = 0;
        while(str[i + index] != '\0')
        {
            str[i] = str[i + index];
            i++;
        }
        str[i] = '\0'; // Make sure that string is NULL terminated
    }
    i=0;
    if((strncmp(str,end,3)==0))
    {
        return strdup(end);
    }
    else if(strncmp(str,timeToStop,10)==0)
    {
        return strdup(timeToStop);
    }
    if(valid(str))
    {
        while(1)
        {
            while (str[i] != '\0' && str[i] != '|' && str[i] != ';')
            {
                command[i] = str[i];
                i++;
            }
            if (str[i] == ';' || str[i] == '\0')
            {
                command[i] = '\0';
                return strdup(command);
            }
            else if (str[i] == '|')
            {
                if(str[i+1]== ' ')
                {
                    if(!valid(str+i+2))
                    {
                        command[i] = '\0';
                        return strdup(command);
                    }
                    command[i] = '|';
                    i++;
                    command[i] = ' ';
                    i++;
                }
                else
                {
                    if(!valid(str+i+1))
                    {
                        command[i] = '\0';
                        return strdup(command);
                    }
                    command[i] = '|';
                    i++;
                }
            }
        }
    }
    else
    {
        return strdup(invalid_cmd);
    }
}

void suicide(int sig_num)
{
    char pid[10] = {0};
    sprintf(pid,"%d", getpid());
    signal(SIGUSR2, suicide);
    fprintf(stderr,"%s\n",pid);
    puts("Child deding");
    sleep(1);
    exit(EXIT_SUCCESS);
}

void kronos(int sig_num)
{
    if(sig_num == 10)
    {
        puts("The walking dead");
        wait_for_ded(sig_num);
    }
    if(sig_num == 12)
    {
        int wait_pid;
        puts("Killing all children");
        kill(-getpid(), SIGUSR2);
        sleep(1);
        while ((wait_pid = wait(0)) > 0);
        puts("Kronos achieved");
        char pid[10] = {0};
        sprintf(pid,"%d", getpid());
        fprintf(stderr,"%s\n",pid);
        exit(EXIT_SUCCESS);
    }
}

void wait_for_ded(int sig_num)
{
    sleep(1);
    wait(NULL);
    //sleep(2);
}

bool valid(char * str)
{
    if((str[0] == 'l' && str[1] == 's' && str[2]==' ') || (str[0] == 'c' && str[1] == 'a' && str[2] == 't' && str[3]==' ') || (str[0] == 'c' && str[1] == 'u' && str[2] == 't' && str[3]==' ') || (str[0] == 'g' && str[1] == 'r' && str[2] == 'e' && str[3] == 'p' && str[4]==' ') || (str[0] == 't' && str[1] == 'r' && str[2]==' '))
    {
        return true;
    }
    return false;
}