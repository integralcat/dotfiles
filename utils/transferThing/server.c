#include <fcntl.h>
#include <netdb.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <unistd.h>
#include <netinet/tcp.h>
#include <netinet/in.h>

#define PORT "6969"
#define BUFFER_SIZE 1048576

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    const char *file_path = argv[1];
    int file_fd = open(file_path, O_RDONLY);
    if (file_fd < 0) {
        perror("open");
        exit(EXIT_FAILURE);
    }

    struct stat st;
    if (fstat(file_fd, &st) < 0) {
        perror("fstat");
        close(file_fd);
        exit(EXIT_FAILURE);
    }

    struct addrinfo hints, *res;
    memset(&hints, 0, sizeof(hints));
    hints.ai_family = AF_INET;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_flags = AI_PASSIVE;

    if (getaddrinfo(NULL, PORT, &hints, &res) != 0) {
        perror("getaddrinfo");
        exit(EXIT_FAILURE);
    }

    int server_fd = socket(res->ai_family, res->ai_socktype, res->ai_protocol);
    if (server_fd < 0) {
        perror("socket");
        freeaddrinfo(res);
        exit(EXIT_FAILURE);
    }

    int flag = 1;
    setsockopt(server_fd, IPPROTO_TCP, TCP_NODELAY, (char *)&flag, sizeof(int));
    if (bind(server_fd, res->ai_addr, res->ai_addrlen) < 0) {
        perror("bind");
        close(server_fd);
        freeaddrinfo(res);
        exit(EXIT_FAILURE);
    }

    listen(server_fd, 10);

    struct sockaddr_storage client_addr;
    socklen_t addr_size = sizeof(client_addr);
    int client_fd = accept(server_fd, (struct sockaddr *)&client_addr, &addr_size);
    if (client_fd < 0) {
        perror("accept");
        close(server_fd);
        close(file_fd);
        exit(EXIT_FAILURE);
    }

    printf("Connection accepted!\n");

    // Send filename
    send(client_fd, file_path, strlen(file_path) + 1, 0);

    // Send file size
    send(client_fd, &st.st_size, sizeof(off_t), 0);

    // Send permissions
    send(client_fd, &st.st_mode, sizeof(mode_t), 0);

    // Send file contents
    char buffer[BUFFER_SIZE];
    ssize_t bytes_read;
    while ((bytes_read = read(file_fd, buffer, sizeof(buffer))) > 0) {
        send(client_fd, buffer, bytes_read, 0);
    }

    printf("File sent successfully.\n");

    close(file_fd);
    close(client_fd);
    close(server_fd);
    freeaddrinfo(res);
    return 0;
}
