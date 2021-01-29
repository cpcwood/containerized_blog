# Containerized Blog

Simple containerized Ruby on Rails blog application, as referenced in [One Way To: Containerize a Rails Application](https://www.cpcwood.com/blog/1-one-way-to-containerize-a-ruby-on-rails-application).

Generated using: ```rails new containerized_blog --skip-spring --skip-listen -d=postgresql```

Containerized using Docker v20.10

## Build image

To build the image, run: ```sudo docker build -t cpcwood/containerized_blog .```


## Run the Container

### Create Configuration

Create configuration file ```config/env_vars/.env```  from the template [```config/env_vars/.env.template```](config/env_vars/.env.template)


### Start with docker-compose

First, ensure the images, mounted volumes, and credentails are correct for your machine in the [```docker-compose.yaml```](docker-compose.yaml).

Then start the containers by running: ```sudo docker-compose up```

Visit the site in your browser on [http://0.0.0.0:5000](http://0.0.0.0:5000)


## LICENSE

MIT