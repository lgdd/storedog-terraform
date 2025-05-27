# Storedog Terraform

Terraform scripts to provision Datadog's [Storedog](https://github.com/DataDog/storedog) demo on AWS.

## Methods

- [Docker Compose on EC2](#docker-compose-on-ec2)

## Docker Compose on EC2
### Tools

The scripts have been tested with:

- [Terraform](https://developer.hashicorp.com/terraform/install) v1.12.1
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) 2.27.19

### Environment Variables

Setting the following environment variables make running terraform plan/apply/destroy commands smoother (otherwise the command ask you to manually enter the value of each parameter):

- `TF_VAR_my_public_ip_cidr`
    - The value should come from the result of `curl -s checkip.amazonaws.com | xargs -I {} echo "{}/32"`.
- `TF_VAR_ec2_key_name`
    - From a [key pair you created for EC2](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html).
- `TF_VAR_dd_api_key`
    - [Datadog API Key](https://docs.datadoghq.com/account_management/api-app-keys/#add-an-api-key-or-client-token) of your organization.
- `TF_VAR_dd_app_key`
    - [Datadog App Key](https://docs.datadoghq.com/account_management/api-app-keys/#add-application-keys) of your organization.
- `TF_VAR_dd_storedog_rum_app_id`
    - From your [RUM setup](https://docs.datadoghq.com/real_user_monitoring/browser/setup/client/?tab=rum#setup).
- `TF_VAR_dd_storedog_rum_client_token`
    - From your [RUM setup](https://docs.datadoghq.com/real_user_monitoring/browser/setup/client/?tab=rum#setup).

### Debug

After running `terraform apply`, the outputs should give you the public IP/DNS of the EC2 instance. You should be able to connect to your instance with `ssh -i ~/.ssh/YOUR_KEY_PAIR ubuntu@YOUR_EC2_IP_OR_DNS`.

It can take a few minutes to start, so if you want to check the progress and see if there's any error with the cloud init script (i.e. [user_data.sh](./ec2-docker-compose/user_data.sh)), you can run the command `tail -f /var/log/cloud-init-output.log`.

If the cloud init script ran successfully, you can go to `~/storedog` and run `sudo docker compose logs -f` to check the logs of the Storedog services (or a specific service like the Datadog agent with `sudo docker compose logs -f dd-agent`).