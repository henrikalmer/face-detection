classdef Tests < matlab.unittest.TestCase
    
    properties
    end
    
    methods (Test)
        %% Test LoadImage
        function testLoadImageIsNormalized(testCase)
            % Verifies that the returned data is normalized
            addpath('Pics/TrainingImages/FACES/');
            im = LoadImage('face00001.bmp');
            testCase.verifyEqual(int64(mean(im(:))), int64(0));
            testCase.verifyEqual(int64(std(im(:))), int64(1));
        end
        
        function testLoadImageCumsum(testCase)
            % Verifies that the integral image contains correct values
            addpath('Pics/TrainingImages/FACES/');
            [im, ii_im] = LoadImage('face00001.bmp');
            testCase.verifyEqual(ii_im(2, 2), sum(sum(im(1:2, 1:2))))
        end
        
        function testLoadImage(testCase)
            % Verify that output from face00001.bmp matched debug data
            addpath('Pics/TrainingImages/FACES/');
            [im, ii_im] = LoadImage('face00001.bmp');
            dinfo1 = load('DebugInfo/debuginfo1.mat');
            tol = 1e-6;
            testCase.verifyEqual(im(:), dinfo1.im(:), 'AbsTol', tol);
            testCase.verifyEqual(ii_im(:), dinfo1.ii_im(:), 'AbsTol', tol);
        end
        
        %% Test ComputeBoxSum
        function testComputeBoxSum(testCase)
            % Verify that ComputeBoxSum does a correct calculation
            addpath('Pics/TrainingImages/FACES/');
            [im, ii_im] = LoadImage('face00001.bmp');
            tol = 1e-6;
            points = [[1 1]; [1 2]; [2 1]; [2 2]; [3 5]];
            for i = 1:size(points, 1)
                x = points(i,1); y = points(i,2);
                w = 6; h = 6;
                expected = sum(sum(im(y:y+h-1, x:x+w-1)));
                actual = ComputeBoxSum(ii_im, x, y, w, h);
                testCase.verifyEqual(actual, expected, 'AbsTol', tol);
            end 
        end
    end
    
end

