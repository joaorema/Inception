Inception Project – 42 Porto

This project implements the classic 42 Inception setup, featuring services like Nginx, WordPress, MariaDB,
plus bonus services including FTP, Redis, Adminer, a custom whoami netcat-based service, and a static HTML page. 
Unlike many others, no official Docker Hub images were used. I built every container from scratch using custom Dockerfiles.

Project Structure
<img width="811" height="539" alt="Screenshot from 2025-08-19 11-50-10" src="https://github.com/user-attachments/assets/00cced76-1f74-4a7d-a0d6-289d63af8bec" />

How It Works

-Custom Docker Images: Each service uses its own Dockerfile and startup script (setup.sh or equivalent), so I fully controlled installation, configuration, and entrypoint behavior.

-Configs & Scripts in dedicated folders: Each service has:
  . conf/ folder containing its .conf files,
  . tools/ folder (or equivalent) with scripts that perform configuration tasks or launch the service.

-Startup Flow:
  1 - Build each service’s Docker image from its directory.
  2 - Within the image, the Dockerfile copies or sets up configuration files and scripts.
  3 - The service’s entrypoint script applies configuration (e.g., generating certs, applying CLI installs, initializing DB) and starts the service.

-Why This Matters
  Demonstrates deep Docker understanding, no reliance on pre built images. Everything is handcrafted from base OS layers.
  Offers modular clarity—each service is self contained with its own folder structure, letting you dive into service specific logic and config.
  Enhances maintainability. Clear breakdown between configuration, setup logic, and runtime behavior.
