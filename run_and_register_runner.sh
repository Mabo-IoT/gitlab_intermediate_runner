#！/bin/bash
special_tag_eqpt_no='AVL_5E01_Can'
gitlab_register='192.168.253.131:10051'
gitlab_runner_address=${gitlab_register}/mabo_group/base_application/intermediate_runner
gitlab_runner_image=${gitlab_runner_address}:latest
helper_image=$gitlab_runner_address/helper:x86_64-4745a6f3
install_file_path=$PWD
cret='192.168.253.131.crt'
url='https://192.168.253.131:2443/'
base_docker_image=${gitlab_register}/mabo/docker_base:latest
registration_token='inAsxLsyByQkckPwuNwg'
# pull gitlab-runner/intermediate_runner
echo '+++++++++pull gitlab-runner/intermediate_runner+++++++++'
docker pull ${gitlab_runner_image}
# register shared runner 
echo '+++++++++register shared runner +++++++++++'
docker run --rm \
-v $install_file_path/config:/etc/gitlab-runner \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /usr/mabo:/urs/mabo \
$gitlab_runner_image register \
    --non-interactive \
    --tls-ca-file /etc/gitlab-runner/certs/${cret} \
    --url $url \
    --registration-token $registration_token \
    --executor "docker" \
    --docker-image $base_docker_image \
    --description "docker-runner" \
    --tag-list "docker" \
    --docker-volumes "/cache" \
    --docker-volumes "/var/run/docker.sock:/var/run/docker.sock" \
    --run-untagged \
    --docker-helper-image ${helper_image} \
    --locked="false"
# register special runner 
echo '+++++++++register special runner +++++++++++'
docker run --rm \
-v $install_file_path/config:/etc/gitlab-runner \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /usr/mabo:/urs/mabo \
$gitlab_runner_image register \
    --non-interactive \
    --tls-ca-file /etc/gitlab-runner/certs/$cret \
    --url $url \
    --builds-dir /usr/mabo \
    --registration-token $registration_token \
    --executor "docker" \
    --description "docker-runner" \
    --tag-list $special_tag_eqpt_no \
    --docker-image $base_docker_image \
    --docker-volumes "/cache" \
    --docker-volumes "/var/run/docker.sock:/var/run/docker.sock" \
    --docker-volumes "/usr/mabo:/usr/mabo" \
    --docker-helper-image ${helper_image} \
    --locked="false"
# change concurrent with sed
sed -i 's/concurrent = 1/concurrent = 2/g' $install_file_path/config/config.toml
# run gitlab-runner
echo '+++++++++run gitlab-runner +++++++++++'
docker run -d --restart=always --name gitlab-runner \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $install_file_path/config:/etc/gitlab-runner \
    -v /usr/mabo:/usr/mabo \
$gitlab_runner_image