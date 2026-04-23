from diagrams import Diagram, Cluster, Edge
from diagrams.aws.network import VPC
from diagrams.aws.compute import EKS
from diagrams.aws.database import RDS
from diagrams.k8s.compute import Pod
from diagrams.k8s.network import Ingress
from diagrams.onprem.monitoring import Zabbix, Grafana
from diagrams.custom import Custom
import urllib.request
import os

# Função para garantir que os logos existam
def download_icon(url, filename):
    if not os.path.exists(filename):
        opener = urllib.request.build_opener()
        opener.addheaders = [('User-agent', 'Mozilla/5.0')]
        urllib.request.install_opener(opener)
        urllib.request.urlretrieve(url, filename)

# URLs dos logos oficiais
logos = {
    "n8n": "https://avatars.githubusercontent.com/u/45401411?s=200&v=4",
    "otel": "https://avatars.githubusercontent.com/u/50654166?s=200&v=4"
}

# Download dos ícones
for name, url in logos.items():
    download_icon(url, f"{name}_logo.png")

graph_attr = {
    "fontsize": "25",
    "bgcolor": "white",
    "splines": "spline"
}

with Diagram("Observability IDP - The Monster (Full Stack)", show=False, filename="monster_architecture", graph_attr=graph_attr):
    
    with Cluster("AWS Cloud (Region: us-east-1)"):
        db_shared = RDS("PostgreSQL Shared\n(Zabbix & n8n)")
        
        with Cluster("VPC Network"):
            with Cluster("Private Subnet (Compute)"):
                eks = EKS("EKS Cluster")
                
                with Cluster("Namespace: monitoring"):
                    # Agora usando Custom Nodes para OTel e Grafana (opcional)
                    otel = Custom("OTel Collector\n(Standardizer)", "otel_logo.png")
                    zbx = Zabbix("Zabbix Server")
                    graf = Grafana("Grafana\n(Loki/Tempo/Mimir)")
                
                with Cluster("Namespace: automation"):
                    automation = Custom("n8n Logic Engine", "n8n_logo.png")

                with Cluster("Namespace: apps (Business)"):
                    app_pods = [Pod("Microservice A"),
                                Pod("Microservice B")]

            with Cluster("Public Subnet (Traffic)"):
                ingress = Ingress("Nginx Ingress Gateway")

    # FLUXO DE DADOS
    app_pods >> Edge(label="OTLP protocol", color="orange") >> otel
    otel >> Edge(label="Traces/Logs", color="darkblue") >> graf
    zbx >> Edge(label="Alerts", color="red") >> automation
    automation >> Edge(label="Self-healing", color="darkgreen", style="dashed") >> eks
    [zbx, automation] >> db_shared
    ingress >> [graf, zbx, automation]