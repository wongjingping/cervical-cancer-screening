# using Udacity's Car Image

gocv # alias for navigating to the project's directory
ssh-add ~/Dropbox/Code/keys/aws_nvirgnia.pem


### ============================== first-time setup ============================== ###

export AWS=34.200.255.9 # change as necessary
ssh ubuntu@$AWS
# update/install software
sudo -H /opt/anaconda3/bin/pip install seaborn
sudo -H /opt/anaconda3/bin/pip install sklearn --upgrade
sudo -H /opt/anaconda3/bin/pip install keras --upgrade
sudo -H /opt/anaconda3/bin/pip install tensorflow --upgrade --ignore-installed
sudo -H /opt/anaconda3/bin/pip install xgboost
sudo -H apt install p7zip-full
# setup repo
git clone https://github.com/wongjingping/cervical-cancer-screening.git
cd cervical-cancer-screening
mkdir models images graph data data/submission
exit

# transfer processed file from local, and unzip
scp data/train.h5 ubuntu@$AWS:cervical-cancer-screening/data
ssh ubuntu@$AWS
cd cervical-cancer-screening/data

# download images from kaggle directly and extract from 7z archive
scp ~/Dropbox/Code/keys/kaggle_cookies.txt ubuntu@$AWS:~/
ssh ubuntu@$AWS
wget --load-cookies ~/kaggle_cookies.txt https://www.kaggle.com/c/intel-mobileodt-cervical-cancer-screening/download/train.7z -O images/train.7z
wget --load-cookies ~/kaggle_cookies.txt https://www.kaggle.com/c/intel-mobileodt-cervical-cancer-screening/download/test.7z -O images/test.7z
wget --load-cookies ~/kaggle_cookies.txt https://www.kaggle.com/c/intel-mobileodt-cervical-cancer-screening/download/additional_Type_1_v2.7z -O images/additional_Type_1_v2.7z
wget --load-cookies ~/kaggle_cookies.txt https://www.kaggle.com/c/intel-mobileodt-cervical-cancer-screening/download/additional_Type_2_v2.7z -O images/additional_Type_2_v2.7z
wget --load-cookies ~/kaggle_cookies.txt https://www.kaggle.com/c/intel-mobileodt-cervical-cancer-screening/download/additional_Type_3_v2.7z -O images/additional_Type_3_v2.7z
cd images
7z x train.7z
7z x test.7z
7z x additional_Type_1_v2.7z
7z x additional_Type_2_v2.7z
7z x additional_Type_3_v2.7z


### ============================== running from AMI ============================== ###

# when resuming
export AWS=34.200.255.9 # change as necessary
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

