# GB-Terraform-MCS
terraform playground for mail ru cloud solution

Задание 1 (обязательное):
Создание отказоустойчивого сетап веб серверов c балансировкой через CLI
• Создание 2 ВМ в двух разных зонах используя CLI
• Создание LB из CLI (требуется установить дополнительный пакет https://docs.openstack.org/python-octaviaclient/latest/)
• Эмуляция падения одной ноды\ЦОД-а (выключение 1 из ВМ) сервис при этом остается доступен
.
Задание 2 (дополнительное):
Создание той же инфраструктуры что из первого задания используя Infrastructure-as-Code (на примере Terraform)
Пример: https://github.com/MailRuCloudSolutions/terraform-demo
Обращаю Ваше внимание, что в примере заведомо допущена ошибка :)
