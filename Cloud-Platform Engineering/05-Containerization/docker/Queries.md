# 🐳 Docker Commands Cheat Sheet

A complete reference of essential **Docker CLI commands** and what they do — categorized for quick lookup and learning.

---

## 🧱 Basic Docker Commands

| Command | Description |
|--------|-------------|
| `docker --version` | Show the installed Docker version. |
| `docker info` | Display system-wide information about Docker. |
| `docker help` | Get help for Docker commands. |

---

## 📦 Image Management

| Command | Description |
|--------|-------------|
| `docker pull <image>` | Download an image from Docker Hub (e.g., `docker pull ubuntu`). |
| `docker build -t <name> .` | Build a Docker image from a Dockerfile in the current directory. |
| `docker images` | List all locally stored Docker images. |
| `docker rmi <image>` | Remove a Docker image by name or ID. |
| `docker tag <image> <repo>:<tag>` | Tag an image for pushing to a registry. |
| `docker push <repo>:<tag>` | Push a tagged image to a remote registry. |

---

## 🚢 Container Management

| Command | Description |
|--------|-------------|
| `docker run <image>` | Run a container from an image. |
| `docker run -it <image> bash` | Run a container in interactive mode with a shell. |
| `docker ps` | List currently running containers. |
| `docker ps -a` | List all containers (running and stopped). |
| `docker stop <container>` | Stop a running container. |
| `docker start <container>` | Start a stopped container. |
| `docker restart <container>` | Restart a container. |
| `docker rm <container>` | Remove a stopped container. |
| `docker exec -it <container> <command>` | Execute a command inside a running container. |
| `docker logs <container>` | Show logs from a container. |

---

## 🛠️ Container Configuration

| Command | Description |
|--------|-------------|
| `docker run -d <image>` | Run container in detached mode (background). |
| `docker run -p 8080:80 <image>` | Map host port to container port. |
| `docker run -v /host:/container <image>` | Mount volume from host to container. |
| `docker inspect <container>` | View detailed info (e.g., IP, mounts) about a container. |
| `docker rename <old_name> <new_name>` | Rename an existing container. |

---

## 📂 Volumes & Storage

| Command | Description |
|--------|-------------|
| `docker volume create <name>` | Create a Docker volume. |
| `docker volume ls` | List all volumes. |
| `docker volume inspect <name>` | View detailed info about a volume. |
| `docker volume rm <name>` | Remove a volume. |

---

## 🖧 Networks

| Command | Description |
|--------|-------------|
| `docker network ls` | List all Docker networks. |
| `docker network inspect <name>` | Show info about a specific network. |
| `docker network create <name>` | Create a new Docker network. |
| `docker network connect <network> <container>` | Connect container to a network. |
| `docker network disconnect <network> <container>` | Disconnect container from a network. |

---

## 🧹 Clean Up Commands

| Command | Description |
|--------|-------------|
| `docker system prune` | Remove unused data (containers, images, volumes, networks). |
| `docker image prune` | Remove unused images. |
| `docker container prune` | Remove stopped containers. |
| `docker volume prune` | Remove unused volumes. |
| `docker network prune` | Remove unused networks. |

---

## 📦 Docker Compose (Bonus)

| Command | Description |
|--------|-------------|
| `docker compose up` | Start services defined in `docker-compose.yml`. |
| `docker compose up -d` | Start services in detached mode. |
| `docker compose down` | Stop and remove all services. |
| `docker compose build` | Build or rebuild services. |
| `docker compose ps` | List running services. |
| `docker compose logs` | View logs of services. |
| `docker compose exec <service> <cmd>` | Execute a command in a running service container. |

---

## 🔍 Quick Tips

- Use `docker container`, `docker image`, `docker volume` instead of shorthand (`docker ps`, `docker rm`) for consistency and clarity.
- Combine commands with filters like `--filter "status=exited"` to narrow results.
- Use `docker system df` to view disk usage summary.

---

## ✅ Best Practices

- Clean up unused containers/images regularly.
- Use `.dockerignore` to reduce image size.
- Always tag your images properly for version control.
- Prefer `docker-compose` for managing multi-container setups.

---

> 📘 **Learn more**: Visit [https://docs.docker.com/](https://docs.docker.com/) for the full official documentation.
