google_region             = "europe-west1" # Belgium
google_monthly_budget_usd = 100

mongodb_atlas_region       = "WESTERN_EUROPE" # Belgium
mongodb_monthly_budget_usd = 20

# ===== Letro

letro_docker_image_tag   = 14
letro_min_instance_count = 0
letro_max_instance_count = 3

# ===== VeraId Authority

veraid_authority_docker_image_tag   = "1.21.2"
veraid_authority_api_auth_audience  = "1053273447752-rtiji7vtdj0b2rd6lpu3dhmglp27qbjf.apps.googleusercontent.com"
veraid_authority_api_superadmin_sub = "114581933583490416140"

veraid_authority_awala_backend_min_instance_count = 0
veraid_authority_queue_min_instance_count         = 0

# ===== Awala Internet Endpoint

awala_endpoint_docker_image_tag = "1.8.16"
awala_endpoint_internet_address = "letro.app"
awala_endpoint_pohttp_domain    = "pohttp.letro.app"

awala_endpoint_client_min_instance_count = 0
