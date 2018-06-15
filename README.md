# openssl

- To create certificate for a host, e.g. ldap.default.svc.cloud.uat:
```console
./create_node.sh -h {HOSTNAME}
```

- To create .jks certificates:
```console
./run.sh -d {DOMAIN_NAME} -p {PASSWORD}
```

## Configuration
The following table lists the configurable parameters of the openssl and their default values.

| Parameter                   | Description                                           | Default                        |
|-----------------------------|-------------------------------------------------------|--------------------------------|
| `MOUNT_PATH`                | The common mount path                                 | `/export`                      |
| `HOSTIP`                    | The ip address of the current host vm.                |                                |
| `CERTIFICATE_MOUNT_PATH`    | The location of the certificates                      | `${MOUNT_PATH}/ssl_certificate`|
