bundle exec jekyl build
gsutil rsync -R _site "gs://$1"
gsutil acl ch -r -u AllUsers:R "gs://$1"
gsutil web set -m index.html "gs://$1"
