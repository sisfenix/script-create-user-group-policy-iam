########################################################
#### Script para criacao dos usuarios, grupos e     ####
#### politicas para acessos os buckets no S3 da AWS ####
#### Criado em: 22/02/2021                          ####
#### Revisão  : 00                                  ####
#### Copyright (c) 2021 by Alan Lopes               ####
########################################################
# 22/02/2021 - VERSAO INICIAL                          #
########################################################

# NECESSARIO AWS CLI INSTALADO E CONFIGURADO

#!/bin/sh

var_lista=lista.txt
var_id_org="111111111111"

echo "Inicio do script..."
echo $(date)
echo 

for I in $(cat $var_lista)
do

  cp modelo.json $I.json
  sed -i "s/modelobucket/$I/g" $I.json

  aws iam create-policy --policy-name pol_s3_prd_$I  --policy-document file://$I.json > /dev/null
  aws iam create-group --group-name grp_s3_prd_$I > /dev/null
  aws iam attach-group-policy  --group-name grp_s3_prd_$I --policy-arn arn:aws:iam::$var_id_org:policy/pol_s3_prd_$I > /dev/null
  aws iam create-user --user-name svc_s3_prd_$I > /dev/null
  aws iam add-user-to-group --user-name svc_s3_prd_$I --group-name grp_s3_prd_$I > /dev/null
  aws iam create-access-key --user-name svc_s3_prd_$I > credencial_$I.txt

  rm -fr $I.json

done

echo 
echo $(date)
echo "Fim do script."
