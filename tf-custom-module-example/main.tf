module "app_topics" {
 source      = "./modules/app_topics"
 name_prefix = "test-vrush"
}
module "app_topics_vrush" {
 source      = "./modules/app_topics"
 name_prefix = "test-vrush"
}

output "cart_topic_arns" {
 value = module.app_topics.cart_topic_arns
  
}