from diagrams import Diagram, Cluster, Edge
from diagrams.aws.network import VPC
from diagrams.aws.compute import EKS
from diagrams.aws.database import RDS
from diagrams.k8s.compute import Pod
from diagrams.k8s.network import Ingress
from diagrams.onprem.monitoring import Grafana
from diagrams.custom import Custom
import os

# Configurações visuais - O EQUILÍBRIO PERFEITO
graph_attr = {
    "fontsize": "25",
    "bgcolor": "white",
    "splines": "spline", # VOLTAMOS COM AS SETAS CURVAS QUE VOCÊ GOSTOU
    "nodesep": "0.4",
    "ranksep": "0.8"
}

with Diagram("Observability IDP - The Monster (Logical Flow)", show=False, filename="monster_architecture", direction="LR", graph_attr=graph_attr):
    
    user_traffic = Ingress("Public Traffic\nGateway")

    with Cluster("AWS Cloud Ecosystem"):
        db_shared = RDS("PostgreSQL Shared\n(Zabbix & n8n)")
        
        with Cluster("Amazon EKS Cluster v1.30"):
            
            with Cluster("Governance & Security"):
                argo = Custom("ArgoCD", "./argocd.png")
                rancher = Custom("Rancher", "./rancher.png")
                cert = Custom("Cert-Manager", "./Cert-Manager.png")

            with Cluster("Observability Stack"):
                otel = Custom("OTel Collector", "./otel_logo.png")
                zbx = Custom("Zabbix Server", "./zabbix.png")
                graf = Grafana("Grafana")
                kuma = Custom("Uptime Kuma", "./kuma.png")

            with Cluster("Automation"):
                n8n = Custom("n8n AI Engine", "./n8n_logo.png")

            with Cluster("Apps"):
                app_pods = [Pod("Microservice A"), Pod("Microservice B")]

    # --- FLUXO DE INTELIGÊNCIA ---
    # Entrada de Usuário
    user_traffic >> Edge(color="blue", style="bold") >> [rancher, zbx, kuma, graf]
    
    # Ciclo de Dados das Apps
    app_pods >> Edge(label="OTLP", color="orange") >> otel >> graf
    
    # Ciclo de Alerta e Auto-cura
    zbx >> Edge(label="Alerts", color="red") >> n8n
    n8n >> Edge(label="Sync", color="darkgreen", style="dashed") >> argo >> app_pods
    
    # Vigilância (Watchdog)
    kuma >> Edge(color="purple", style="dotted") >> [zbx, rancher, argo]

    # Persistência de Dados
    [zbx, n8n] >> db_shared