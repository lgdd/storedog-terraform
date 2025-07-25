import yaml
import requests

def remove_build_attribute(compose, services):
    for service in services:
        if compose["services"][service].get("build") is not None:
            del compose["services"][service]["build"]

def update_volumes_attribute(compose, services):
    for service in services:
        if compose["services"][service].get("volumes") is not None:
            del compose["services"][service]["volumes"]
    compose["services"]["backend"]["volumes"] = [".env:/app/.env"]
    compose["services"]["frontend"]["volumes"] = [".env:/app/.env"]

def update_networks(compose):
    for network in compose["networks"]:
            compose["networks"][network] = {"name": f"storedog_{network}"}

def update_volumes(compose):
    for volume in compose["volumes"]:
        compose["volumes"][volume] = {"name": f"storedog_{volume}"}

def add_image_attribute(compose, services):
    compose["services"]["worker"] = dict(
        {"image": f"ghcr.io/datadog/storedog/backend:latest"},
        **compose["services"]["worker"]
    )
    for service in services:
        if service == "ads":
            compose["services"][service] = dict(
                {"image": f"ghcr.io/datadog/storedog/{service}-java:latest"},
                **compose["services"][service]
            )
        if service == "service-proxy":
            compose["services"][service] = dict(
                {"image": f"ghcr.io/datadog/storedog/nginx:latest"},
                **compose["services"][service]
            )
        else:
            compose["services"][service] = dict(
                {"image": f"ghcr.io/datadog/storedog/{service}:latest"},
                **compose["services"][service]
            )

if __name__ == "__main__":
    services = ["frontend", "backend", "discounts", "ads", "service-proxy", "postgres"]
    origin = "https://raw.githubusercontent.com/DataDog/storedog/refs/heads/main/docker-compose.yml"
    response = requests.get(origin)
    compose = yaml.safe_load(response.text)

    add_image_attribute(compose, services)
    remove_build_attribute(compose, services)
    update_volumes_attribute(compose, services)
    
    update_volumes(compose)
    update_networks(compose)

    with open("docker-compose.images.yml", "w") as file:
        file.write(
            yaml.dump(compose, sort_keys=False)
        )
