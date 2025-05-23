locals {
  buckets = {
    "my-bucket-1" = "team-a" 
    "my-bucket-2" = "team-b"  
    "my-bucket-3" = "team-c" 
  }
}

module "s3-buckets" {
  for_each    = local.buckets
  source      = "./modules/s3-buckets"
  bucket_name = each.key
  
}