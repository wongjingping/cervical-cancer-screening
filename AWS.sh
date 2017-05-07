# using Udacity's Car Image

gocv # alias for navigating to the project's directory
ssh-add ~/Dropbox/Code/keys/aws_nvirgnia.pem


### ============================== first-time setup ============================== ###

export AWS=54.164.74.213 # change as necessary
ssh ubuntu@$AWS
# update/install software
pip install seaborn
sudo apt install 7z
# setup repo
git clone https://github.com/wongjingping/cervical-cancer-screening.git
mkdir 
cd cervical-cancer-screening
mkdir models data images graph
exit

# transfer processed file from local, and unzip
scp data/train.h5 ubuntu@$AWS:cervical-cancer-screening/data
ssh ubuntu@$AWS
cd cervical-cancer-screening/data

# download images from kaggle directly and extract from 7z archive
scp ~/Dropbox/Code/keys/kaggle_cookies.txt ubuntu@$AWS:~/
ssh ubuntu@$AWS
wget --load-cookies kaggle_cookies.txt https://www.kaggle.com/c/intel-mobileodt-cervical-cancer-screening/download/train.7z -O images/train.7z
wget --load-cookies kaggle_cookies.txt https://www.kaggle.com/c/intel-mobileodt-cervical-cancer-screening/download/test.7z -O images/test.7z
7z x images/train.7z
7z x images/test.7z


### ============================== running from AMI ============================== ###

# when resuming
export AWS=54.242.119.44 # change as necessary
# export AWS=54.82.68.61 # fold 1
# export AWS=52.90.211.155 # fold 2
ssh ubuntu@$AWS
cd cervical-cancer-screening
git checkout -- .
git pull origin master
screen
jupyter notebook --no-browser --ip=0.0.0.0 --port=8888
tensorboard --logdir graph --port 6006 # ctrl-a-c to open a new screen and start tensorboard there

# copy models down
function awsdn() {
  scp ubuntu@$AWS:~/cervical-cancer-screening/models/"$@" models
}

