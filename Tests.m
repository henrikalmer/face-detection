classdef Tests < matlab.unittest.TestCase
    
    properties
        OriginalPath
    end
    
    methods (TestMethodSetup)
        function addImagesToPath(testCase)
            testCase.OriginalPath = path;
            addpath('Pics/TrainingImages/FACES/');
        end
    end
    
    methods (TestMethodTeardown)
        function restorePath(testCase)
            path(testCase.OriginalPath);
        end
    end
    
    methods (Test)
        %% Test LoadImage
        function testLoadImageIsNormalized(testCase)
            % Verifies that the returned data is normalized
            im = LoadImage('face00001.bmp');
            testCase.verifyEqual(int64(mean(im(:))), int64(0));
            testCase.verifyEqual(int64(std(im(:))), int64(1));
        end
        
        function testLoadImageCumsum(testCase)
            % Verifies that the integral image contains correct values
            [im, ii_im] = LoadImage('face00001.bmp');
            testCase.verifyEqual(ii_im(2, 2), sum(sum(im(1:2, 1:2))))
        end
        
        function testLoadImage(testCase)
            % Verify that output from face00001.bmp matched debug data
            [im, ii_im] = LoadImage('face00001.bmp');
            dinfo1 = load('DebugInfo/debuginfo1.mat');
            tol = 1e-6;
            testCase.verifyEqual(im(:), dinfo1.im(:), 'AbsTol', tol);
            testCase.verifyEqual(ii_im(:), dinfo1.ii_im(:), 'AbsTol', tol);
        end
        
        %% Test ComputeBoxSum
        function testComputeBoxSum(testCase)
            % Verify that ComputeBoxSum does a correct calculation
            [im, ii_im] = LoadImage('face00001.bmp');
            tol = 1e-6;
            inputs = [[1 1 4 6];
                      [1 2 7 2];
                      [2 1 3 9];
                      [2 2 10 10];
                      [3 5 5 5]];
            for i = 1:size(inputs, 1)
                x = inputs(i,1); y = inputs(i,2);
                w = inputs(i,3); h = inputs(i,4);
                expected = sum(sum(im(y:y+h-1, x:x+w-1)));
                actual = ComputeBoxSum(ii_im, x, y, w, h);
                testCase.verifyEqual(actual, expected, 'AbsTol', tol);
            end
        end
        
        %% Test Feature computation
    end
    
end

