# Copyright (c) 2020, 2021, Oracle and/or its affiliates.
#
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/
#

from typing import Callable, Optional, TypeVar
from kubernetes.client.rest import ApiException
from kubernetes import client, config

try:
    # outside k8s
    config.load_kube_config()
except config.config_exception.ConfigException:
    try:
        # inside a k8s pod
        config.load_incluster_config()
    except config.config_exception.ConfigException:
        raise Exception(
            "Could not configure kubernetes python client")

api_core: client.CoreV1Api = client.CoreV1Api()
api_customobj: client.CustomObjectsApi = client.CustomObjectsApi()
api_apps: client.AppsV1Api = client.AppsV1Api()
api_batch: client.BatchV1Api = client.BatchV1Api()
api_cron_job: client.BatchV1Api = client.BatchV1Api()
api_policy: client.PolicyV1Api = client.PolicyV1Api()
api_rbac: client.RbacAuthorizationV1Api = client.RbacAuthorizationV1Api()
api_client: client.ApiClient = client.ApiClient()
api_apis: client.ApisApi() = client.ApisApi()

T = TypeVar("T")


def catch_404(f: Callable[..., T]) -> Optional[T]:
    try:
        return f()
    except ApiException as e:
        if e.status == 404:
            return None
        raise


def available_apis():
    return api_apis.get_api_versions()

def k8s_version() -> str:
    api_instance = client.VersionApi(api_client)

    api_response = api_instance.get_code()
    return f"{api_response.major}.{api_response.minor}"
