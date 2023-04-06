#! /bin/bash
sudo chmod 777 /home/ubuntu/Advisory_Chat_Bot
cd /home/ubuntu/Advisory_Chat_Bot
nohup sudo rasa run -m models --enable-api --cors "*" &
nohup sudo rasa run actions &