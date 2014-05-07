function ComputeSaveFData(all_ftypes, f_sfn)
%COMPUTESAVEFDATA Writes computed feature data to file 'f_sfn'

W = 19;
H = 19;
fmat = VecAllFeatures(all_ftypes, 19, 19);
save(f_sfn, 'fmat', 'all_ftypes', 'W', 'H');

end

