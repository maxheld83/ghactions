# I am a comment
docker run \
  --env=PASSWORD=foo `# some environmental vars` \
  --rm  `# make container ephemeral` \
  -d \
  --volume=/Users/max/GitHub/ghactions:/home/rstudio/ghactions \
  --publish=8787:8787  `# port mapping, host left, cont right`\
  --name="ghactions" \
  ghactions `# the image`
