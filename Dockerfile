FROM almalinux:9

# Update system and install EPEL repository
RUN dnf update -y && \
    dnf install -y epel-release && \
    dnf clean all

# ── PostgreSQL ────────────────────────────────────────────────────────────────
RUN dnf install -y postgresql-server postgresql-contrib python3-psycopg2 && \
    postgresql-setup --initdb && \
    dnf clean all

# ── Python 3.11 ───────────────────────────────────────────────────────────────
RUN dnf install -y python3.11 python3-devel openldap-devel && \
    dnf clean all

# ── Node.js 20 ────────────────────────────────────────────────────────────────
RUN dnf module enable nodejs:20 -y && \
    dnf install -y nodejs npm && \
    dnf clean all

# ── Build tools and libraries ─────────────────────────────────────────────────
# gcc / gcc-c++ and boost are installed for UDA testing (not in active use)
RUN dnf install -y \
    gcc \
    gcc-c++ \
    boost \
    boost-devel \
    hdf5 \
    hdf5-devel \
    git && \
    dnf clean all

# ── InfluxData repository (Telegraf + InfluxDB2) ─────────────────────────────
RUN printf '[influxdata]\n\
name=InfluxData Repository - Stable\n\
baseurl=https://repos.influxdata.com/rhel/9/$basearch/stable\n\
enabled=1\n\
gpgcheck=1\n\
gpgkey=https://repos.influxdata.com/influxdata-archive_compat.key\n' \
    > /etc/yum.repos.d/influxdata.repo

RUN dnf install -y telegraf influxdb2 && \
    dnf clean all

# ── Grafana repository ────────────────────────────────────────────────────────
RUN printf '[grafana]\n\
name=grafana\n\
baseurl=https://rpm.grafana.com\n\
repo_gpgcheck=1\n\
enabled=1\n\
gpgcheck=1\n\
gpgkey=https://rpm.grafana.com/gpg.key\n\
sslverify=1\n\
sslcacert=/etc/pki/tls/certs/ca-bundle.crt\n' \
    > /etc/yum.repos.d/grafana.repo

RUN dnf install -y grafana && \
    dnf clean all

CMD ["/bin/bash"]
