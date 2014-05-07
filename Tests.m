classdef Tests < matlab.unittest.TestCase
    
    properties
    end
    
    methods (Test)
        function testLoadImageIsNormalized(testCase)
            addpath('Pics/TrainingImages/FACES/');
            im = LoadImage('face00001.bmp');
            testCase.verifyEqual(int64(mean(im)), int64(0));
            testCase.verifyEqual(int64(std(im)), int64(1));
        end
    end
    
end

