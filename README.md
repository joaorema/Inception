Inception Project – 42 Porto

This project implements the classic 42 Inception setup, featuring services like Nginx, WordPress, MariaDB,
plus bonus services including FTP, Redis, Adminer, a custom whoami netcat-based service, and a static HTML page. 
Unlike many others, no official Docker Hub images were used. I built every container from scratch using custom Dockerfiles.

Project Structure
srcs/
  ├── nginx/
  │   ├── Dockerfile
  │   ├── conf/               ← Nginx configuration files (e.g., nginx.conf, SSL settings)
  │   └── tools/              ← Startup scripts (e.g., setup.sh for SSL and nginx launch)
  │
  ├── wordpress/
  │   ├── Dockerfile
  │   ├── conf/               ← PHP-FPM configuration (e.g., www.conf)
  │   └── tools/              ← WordPress setup script (e.g., using WP-CLI to install and configure)
  │
  ├── mariadb/
  │   ├── Dockerfile
  │   ├── conf/               ← MariaDB configuration (e.g., custom `*.cnf` files)
  │   └── tools/              ← Initialization scripts (e.g., init SQL, setup.sh)
  │
  ├── ftp/                     ← FTP service (Dockerfile, config, and startup scripts)
  ├── redis/                   ← Redis service (Dockerfile, config)
  ├── adminer/                 ← Adminer interface (Dockerfile, config)
  ├── whoami/                  ← "Whoami" netcat based service (Dockerfile + script showing uptime, time, container ID)
  └── static/                  ← Static HTML page (Dockerfile, HTML content)

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
