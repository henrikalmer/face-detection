function GetTrainingData(all_ftypes, np, nn)
%GETTRAININGDATA Loads all training data and computes feature vectors

LoadSaveImData('Pics/TrainingImages/FACES', np, 'FaceData.mat');
LoadSaveImData('Pics/TrainingImages/NFACES', nn, 'NonFaceData.mat');
ComputeSaveFData(all_ftypes, 'FeaturesToUse.mat');

end

