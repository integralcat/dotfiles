import socket
import json
import threading
import os

SERVER_HOST = "127.0.0.1"  # or local IP
SERVER_PORT = 7777
BUFFER_SIZE = 1024

def receive_metadata(conn) -> dict:
    data = conn.recv(1024)
    return json.loads(data.decode())

def download_chunk(chunk_index: int):
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as client:
        client.connect((SERVER_HOST, SERVER_PORT))
        metadata = receive_metadata(client)

        file_name = metadata["file_name"]
        file_size = metadata["file_size"]
        thread_count = metadata["thread_count"]
        buffer_size = metadata["buffer_size"]

        chunk_size = file_size // thread_count
        start = chunk_index * chunk_size
        end = file_size if chunk_index == thread_count - 1 else start + chunk_size
        expected = end - start

        out_file = f"{file_name}.part{chunk_index}"
        with open(out_file, "wb") as f:
            received = 0
            while received < expected:
                packet = client.recv(min(buffer_size, expected - received))
                if not packet:
                    break
                f.write(packet)
                received += len(packet)
                percent = (received / expected) * 100
                print(f"[Chunk {chunk_index}] {percent:.2f}%", end="\r")
        print(f"\n[Chunk {chunk_index}] Saved to {out_file}")

def merge_chunks(base_name: str, total_chunks: int):
    output_file = base_name.replace(".gz", ".final")
    with open(output_file, "wb") as out:
        for i in range(total_chunks):
            part_file = f"{base_name}.part{i}"
            with open(part_file, "rb") as pf:
                out.write(pf.read())
            os.remove(part_file)
    print(f"[Client] Merged all parts to {output_file}")

def main():
    threads = []
    for i in range(8):
        t = threading.Thread(target=download_chunk, args=(i,))
        threads.append(t)
        t.start()

    for t in threads:
        t.join()

    merge_chunks("data.mkv.gz", 8)

if __name__ == "__main__":
    main()
