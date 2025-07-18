#include <netdb.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <unistd.h>
#include <time.h>

#define PORT "6969"
#define BUFFER_SIZE 65536 // 64 KB

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <server-hostname>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    struct addrinfo hints, *res;
    memset(&hints, 0, sizeof(hints));
    hints.ai_family = AF_INET;
    hints.ai_socktype = SOCK_STREAM;

    if (getaddrinfo(argv[1], PORT, &hints, &res) != 0) {
        perror("getaddrinfo");
        exit(EXIT_FAILURE);
    }

    int sock_fd = socket(res->ai_family, res->ai_socktype, res->ai_protocol);
    if (sock_fd < 0) {
        perror("socket");
        freeaddrinfo(res);
        exit(EXIT_FAILURE);
    }

    if (connect(sock_fd, res->ai_addr, res->ai_addrlen) < 0) {
        perror("connect");
        close(sock_fd);
        freeaddrinfo(res);
        exit(EXIT_FAILURE);
    }

    printf("Connected to server.\n");

    // Receive filename
    char file_name[512];
    if (recv(sock_fd, file_name, sizeof(file_name), 0) <= 0) {
        perror("recv filename");
        exit(EXIT_FAILURE);
    }

    // Receive file size
    off_t file_size;
    if (recv(sock_fd, &file_size, sizeof(file_size), 0) <= 0) {
        perror("recv file size");
        exit(EXIT_FAILURE);
    }

    // Receive permissions
    mode_t file_mode;
    if (recv(sock_fd, &file_mode, sizeof(file_mode), 0) <= 0) {
        perror("recv mode");
        exit(EXIT_FAILURE);
    }

    FILE *out_file = fopen(file_name, "wb");
    if (!out_file) {
        perror("fopen");
        exit(EXIT_FAILURE);
    }

    char buffer[BUFFER_SIZE];
    ssize_t bytes_read;
    off_t total_received = 0;
    time_t start_time = time(NULL);

    // Receiving file content + progress bar
    while ((bytes_read = recv(sock_fd, buffer, sizeof(buffer), 0)) > 0) {
        fwrite(buffer, 1, bytes_read, out_file);
        total_received += bytes_read;

        float percent = (float)total_received / file_size * 100;
        time_t now = time(NULL);
        double elapsed = difftime(now, start_time);
        double speed = total_received / (elapsed ? elapsed : 1); // bytes/sec
        double eta = (file_size - total_received) / (speed ? speed : 1); // seconds

        printf("\rProgress: %6.2f%% | Speed: %.2f MB/s | ETA: %.0f sec ",
               percent, speed / (1024 * 1024), eta);
        fflush(stdout);
    }

    printf("\nDownload complete.\n");

    fclose(out_file);
    chmod(file_name, file_mode);

    close(sock_fd);
    freeaddrinfo(res);
    return 0;
}
