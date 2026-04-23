#!/bin/bash
sudo apt update 
sudo apt install -y python3 python3-pip python3-venv git
git pull
python3 -m venv .venv 
source .venv/bin/activate
pip install -r requirements.txt
python3 django-site/manage.py migrate
explorer.exe http://localhost:5555
python3 django-site/manage.py runserver 5555
