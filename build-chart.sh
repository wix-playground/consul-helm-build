mkdir build
mkdir prevdata

git clone https://github.com/hashicorp/consul-helm consul
aws s3 cp s3://helm-repo.sphera.tools/consul prevdata --recursive || true
cd consul && helm package ./ && cd ..
mv consul/*.tgz build/
if test -f prevdata/index.yaml; then
    echo 'Merging with previous data'
    mv prevdata/*.tgz build/ || true
    helm repo index build/ --merge prevdata/index.yaml --url http://helm-repo.sphera.tools.s3-website-us-east-1.amazonaws.com/consulv3
else
    echo 'No previous charts to merge'
    helm repo index build/ --url http://helm-repo.sphera.tools.s3-website-us-east-1.amazonaws.com/consulv3
fi