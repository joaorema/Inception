################################################################################
#                                     CONFIG                                   #
################################################################################

NAME		= inception
SRCS		= ./srcs
COMPOSE		= $(SRCS)/docker-compose.yml
HOST_URL	= jpedro-c.42.fr

################################################################################
#                                  RULES                                       #
################################################################################

all: $(NAME)

$(NAME): start

# puts the url in the host files and starts the containers trough docker compose
start: create_dir fix_static_permissions
	@sudo hostsed add 127.0.0.1 $(HOST_URL) > $(HIDE) && echo " $(HOST_ADD)"
	@docker compose -p $(NAME) -f $(COMPOSE) up --build || (echo " $(FAIL)" && exit 1)
	@echo " $(UP)"
	
fix_static_permissions:
	@sudo chown -R $(shell id -u):$(shell id -g) ./srcs/static_site
	@chmod -R 755 ./srcs/static_site
	@chmod 644 ./srcs/static_site/index.html

# stops the containers through docker compose
remove:
	@docker compose -p $(NAME) down
	@echo " $(DOWN)"

create_dir:
	@mkdir -p ~/data/database
	@mkdir -p ~/data/wordpress_files
	@mkdir -p ~/data/redis_data
	@mkdir -p ~/data/ftpuser

# creates a backup of the data folder in the home directory
backup:
	@if [ -d ~/data ]; then sudo tar -czvf ~/data.tar.gz -C ~/ data/ > $(HIDE) && echo " $(BKP)" ; fi

# stop the containers, remove the volumes and remove the containers
clean:
	@docker compose -f $(COMPOSE) down -v
	@if [ -n "$$(docker ps -a --filter "name=nginx" -q)" ]; then docker rm -f nginx > $(HIDE) && echo " $(NX_CLN)" ; fi
	@if [ -n "$$(docker ps -a --filter "name=wordpress" -q)" ]; then docker rm -f wordpress > $(HIDE) && echo " $(WP_CLN)" ; fi
	@if [ -n "$$(docker ps -a --filter "name=mariadb" -q)" ]; then docker rm -f mariadb > $(HIDE) && echo " $(DB_CLN)" ; fi
	@if [ -n "$$(docker ps -a --filter "name=redis" -q)" ]; then docker rm -f redis > $(HIDE) && echo " $(REDIS_CLN)" ; fi
	@if [ -n "$$(docker ps -a --filter "name=ftp" -q)" ]; then docker rm -f ftp > $(HIDE) && echo " $(FTP_CLN)" ; fi

# backups the data and removes the containers, images and the host url from the host file
fclean: clean backup
	@sudo rm -rf ~/data
	@if [ -n "$$(docker image ls $(NAME)-nginx -q)" ]; then docker image rm -f $(NAME)-nginx > $(HIDE) && echo " $(NX_FLN)" ; fi
	@if [ -n "$$(docker image ls $(NAME)-wordpress -q)" ]; then docker image rm -f $(NAME)-wordpress > $(HIDE) && echo " $(WP_FLN)" ; fi
	@if [ -n "$$(docker image ls $(NAME)-mariadb -q)" ]; then docker image rm -f $(NAME)-mariadb > $(HIDE) && echo " $(DB_FLN)" ; fi
	@if [ -n "$$(docker image ls $(NAME)-redis -q)" ]; then docker image rm -f $(NAME)-redis > $(HIDE) && echo " $(REDIS_FLN)" ; fi
	@if [ -n "$$(docker image ls $(NAME)-ftp -q)" ]; then docker image rm -f $(NAME)-ftp > $(HIDE) && echo " $(FTP_FLN)" ; fi
	@sudo hostsed rm 127.0.0.1 $(HOST_URL) > $(HIDE) && echo " $(HOST_RM)"

status:
	@clear
	@echo "\nCONTAINERS\n"
	@docker ps -a
	@echo "\nIMAGES\n"
	@docker image ls
	@echo "\nVOLUMES\n"
	@docker volume ls
	@echo "\nNETWORKS\n"
	@docker network ls --filter "name=$(NAME)_all"
	@echo ""

# remove all containers, images, volumes and networks to start with a clean state
prepare:
	@echo "\nPreparing to start with a clean state..."
	@echo "\nCONTAINERS STOPPED\n"
	@if [ -n "$$(docker ps -qa)" ]; then docker stop $$(docker ps -qa) ;	fi
	@echo "\nCONTAINERS REMOVED\n"
	@if [ -n "$$(docker ps -qa)" ]; then docker rm $$(docker ps -qa) ; fi
	@echo "\nIMAGES REMOVED\n"
	@if [ -n "$$(docker images -qa)" ]; then docker rmi -f $$(docker images -qa) ; fi
	@echo "\nVOLUMES REMOVED\n"
	@if [ -n "$$(docker volume ls -q)" ]; then docker volume rm $$(docker volume ls -q) ; fi
	@echo "\nNETWORKS REMOVED\n"
	@if [ -n "$$(docker network ls -q) " ]; then docker network rm $$(docker network ls -q) 2> /dev/null || true ; fi 
	@echo ""

re: fclean all

################################################################################
#                                  COLORS                                      #
################################################################################

HIDE		= /dev/null 2>&1

RED		= \033[0;31m
GREEN		= \033[0;32m
RESET		= \033[0m

MARK		= $(GREEN)✔$(RESET)
ADDED		= $(GREEN)Added$(RESET)
REMOVED		= $(GREEN)Removed$(RESET)
STARTED		= $(GREEN)Started$(RESET)
STOPPED		= $(GREEN)Stopped$(RESET)
CREATED		= $(GREEN)Created$(RESET)
EXECUTED	= $(GREEN)Executed$(RESET)

################################################################################
#                                 MESSAGES                                     #
################################################################################

UP		= $(MARK) $(NAME)		$(EXECUTED)
DOWN		= $(MARK) $(NAME)		$(STOPPED)
FAIL		= $(RED)✔$(RESET) $(NAME)		$(RED)Failed$(RESET)

HOST_ADD	= $(MARK) Host $(HOST_URL)		$(ADDED)
HOST_RM		= $(MARK) Host $(HOST_URL)		$(REMOVED)

NX_CLN		= $(MARK) Container nginx		$(REMOVED)
WP_CLN		= $(MARK) Container wordpress		$(REMOVED)
DB_CLN		= $(MARK) Container mariadb		$(REMOVED)
REDIS_CLN	= $(MARK) Container redis		$(REMOVED)
FTP_CLN		= $(MARK) Container ftp			$(REMOVED)
NX_FLN		= $(MARK) Image $(NAME)-nginx		$(REMOVED)
WP_FLN		= $(MARK) Image $(NAME)-wordpress	$(REMOVED)
DB_FLN		= $(MARK) Image $(NAME)-mariadb		$(REMOVED)
REDIS_FLN	= $(MARK) Image $(NAME)-redis		$(REMOVED)
FTP_FLN		= $(MARK) Image $(NAME)-ftp		$(REMOVED)


BKP		= $(MARK) Backup at $(HOME)	$(CREATED)

# Phony -----------------------------------------------------------------------

.PHONY: all up down create_dir clean fclean status backup prepare re
