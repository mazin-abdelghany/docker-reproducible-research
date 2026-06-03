# Getting started with `docker compose`

Navigate to this directory and run
```
docker compose -f rstudio-compose.yaml up -d
```
Once the command had completed, point the browser to `localhost:8787`. Type the username `rstudio` and the password `my-password-here`. RStudio should now be in front of you. Set the working directory to `/project` and then click the small arrow above the script window to navigate the file browser to this directory. You should be able to see the file contents of `research-example`.
