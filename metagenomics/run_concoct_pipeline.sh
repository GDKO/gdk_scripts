if [ ! -n "$6" ]
then
  echo "Not enough arguments"
  echo "Usage: run_concoct_pipeline.sh [min_contig_length] [max_clusters] [assembly_file] [coverage_filename] [taxonomy_file] [output_prefix]"
  exit
fi

LEN=$1
MAX_CLUSTERS=$2
ASSEMBLY=$3
COV_FILE=$4
TAXONOMY=$5
PREFIX=$6
CONCOCT_PATH=/exports/software/concoct/CONCOCT/scripts

concoct -l $LEN -c $MAX_CLUSTERS --coverage_file $COV_FILE --composition_file $ASSEMBLY -b $PREFIX

Rscript $CONCOCT_PATH/ClusterPlot.R -c $PREFIX"_clustering_gt"$LEN".csv" -p $PREFIX"_PCA_transformed_data_gt"$LEN".csv" -m $PREFIX"_pca_means_gt"$LEN".csv" -r $PREFIX"_pca_variances_gt"$LEN"_dim" -l -o $PREFIX"_ClusterPlot_"$LEN".pdf"

$CONCOCT_PATH/Validate.pl --cfile=$PREFIX"_clustering_gt"$LEN".csv" --sfile=$TAXONOMY --ffile=$ASSEMBLY --ofile=$PREFIX"_taxonomic_groups_conf"$LEN".csv"

Rscript $CONCOCT_PATH/ConfPlot.R -c $PREFIX"_taxonomic_groups_conf"$LEN".csv" -o $PREFIX"_taxonomic_groups_conf"$LEN".pdf"
