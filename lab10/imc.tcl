load -run test_rand
report -detail -out coverage.rpt -metrics all   -source on
merge test_dir -out merged_data -initial_model test_rand
#load -run merged_data
#report -detail -out merged.rpt -metrics all   -source on
quit