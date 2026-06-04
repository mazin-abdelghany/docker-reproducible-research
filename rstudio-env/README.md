# Getting started with `docker compose`

**Navigate using `cd` to this directory on your local machine and run:**
```
docker compose -f rstudio-compose.yaml up -d
```
Once the command had completed:

1. Point the browser to `localhost:8787`.
2. Type the username `rstudio` and the password `my-password-here`.
3. RStudio should now be in front of you.
4. Set the working directory to `/project`.
5. Click the small arrow at the top of the console next to `R 4.6.0`.
6. You should be able to see the file contents of [`research-example`](../research-example).

If you'd like, you can run the RMarkdown file to see if everything works! We will discuss how all of this is made possible using Docker during the tutorial! :)
