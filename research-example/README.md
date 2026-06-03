# Anatomy of a `docker run` command

When a `docker run` command is entered, it sends a request to the Docker daemon to take a reproducible research environment (an **image**) and translate it into an active and isolated workspace (a **container**). One of the simplest `docker run` commands, for example, would be
```
docker run --rm -ti r-base
```

| Component | Function |
| :--- | :--- |
| **`--rm`** | **Automatically clean up:** Tells Docker to completely delete the container when it stops running, preventing clutter on your hard drive. |
| **`-ti`** | **Interactive terminal:** A combination of `-t` (allocates a terminal) and `-i` (keeps input open). This allows you to type directly into the R console. |
| **`r-base`** | **Image:** Specifies the official, bare-bones R environment image. With no specific version tag (e.g., `:4.3.0`), it defaults to `:latest`. |

What happens when you press Enter?
1. Docker checks if you have the `r-base` image downloaded locally. If not, it downloads it.
2. It launches the container and immediately drops you directly into an interactive R console (`>  ` prompt) inside your terminal.
3. You can run your calculations or test code.
4. When you type q() to exit R, the container stops, and `--rm` instantly deletes it, keeping your computer clean.

As more is needed from a container, the `run` commands can get quite long, e.g.,
```
docker run -d --name gene-analysis -p 8787:8787 -v /Users/biostats/data:/home/rstudio/data --env PASSWORD=research2026 rocker/tidyverse:latest
```
<br>
Here is a breakdown of the command:

| Component | From example | Function |
| :--- | :--- | :--- |
| **The Base Command** | `docker run` | Tells Docker to spin up a new containerized environment. |
| **Execution Mode** | `-d` | **Detached:** Runs the R environment in the background so you can close your terminal without killing your analysis. |
| **Container Naming** | `--name gene-analysis` | Assigns a custom name to the container so you can easily stop, start, or track it. |
| **Port Mapping** | `-p 8787:8787` | Maps the container's port to your local machine. Port `8787` is the standard port for RStudio Server. This lets you open your browser and type `localhost:8787` to access RStudio. |
| **Volume Mounting** | `-v /Users/biostats/data:/home/rstudio/data` | Connects your local dataset folder to a folder inside the R container. Any code you write or clean data you save here persists on your actual hard drive. |
| **Environment Variables** | `--env PASSWORD=research2026` | Passes configurations into the container. For the `rocker` R images, this specifically sets the login password for the RStudio browser interface. |
| **The Image & Tag** | `rocker/tidyverse:latest` | **Mandatory** Specifies the image. Here, we are using the Rocker project's image pre-loaded with R, RStudio, and tidyverse. |

# `docker compose`

With typical research workflow commands containing many options/flags, it becomes more difficult (1) to remember the entire command and (2) type into the console each time. `docker compose` obviates the need for a long `docker run` command by building it into a file.

By saving a file named `compose.yaml` (preferred) or `compose.yml`, the flags and options after `docker run` are saved and run with a simple, single command. Taking our long command from earlier, the corresonding `compose.yaml` file would look like:

```
name: research-env

services:
  r-workspace:
    image: rocker/tidyverse:latest
    container_name: gene-analysis
    ports:
      - "8787:8787"
    volumes:
      - type: bind
        source: /Users/biostats/data
        target: /home/rstudio/data
    environment:
      - PASSWORD=research2026
    restart: always
```
| docker run | docker compose | Function |
| :--- | :--- | :--- |
| *(At the end of command)* | `image: rocker/tidyverse:latest` | Specifies the base environment. |
| `--name gene-analysis` | `container_name: gene-analysis` | Assigns a name to the container. |
| `-p 8787:8787` | `ports:`<br>`  - "8787:8787"` | Maps the RStudio web interface port to local browser. |
| `-v /Users/biostats/data...` | `volumes:`<br>`  - /Users/biostats/data...` | Links local hard drive folders to container for data persistence. |
| `--env PASSWORD=...` | `environment:`<br>`  - PASSWORD=...` | Passes the RStudio login password into the container. |

To run the container specified by the `compose.yaml`, the command is
```
docker compose up [-d]
```
`-d` is the detached option that can be used to run the container in the background as noted above.

Lastly, `docker compose` can be combined with `Dockerfile`s to specify a custom Docker container. See [rstudio-env](../rstudio-env).
