classdef Tests < matlab.unittest.TestCase
    
    properties
        OriginalPath
        Fdata
        NFdata
        FTdata
    end
    
    methods (TestMethodSetup)
        function addImagesToPath(testCase)
            testCase.OriginalPath = path;
            addpath('Pics/TrainingImages/FACES/');
        end
        
        function loadTrainingData(testCase)
            testCase.Fdata = load('FaceData.mat');
            testCase.NFdata = load('NonFaceData.mat');
            testCase.FTdata = load('FeaturesToUse.mat');
        end
    end
    
    methods (TestMethodTeardown)
        function restorePath(testCase)
            path(testCase.OriginalPath);
        end
    end
    
    methods (Test)
        %% Test image loading
        function testLoadImageIsNormalized(testCase)
            % Verify that the returned data is normalized
            im = LoadImage('face00001.bmp');
            testCase.verifyEqual(int64(mean(im(:))), int64(0));
            testCase.verifyEqual(int64(std(im(:))), int64(1));
        end
        
        function testLoadImageCumsum(testCase)
            % Verify that the integral image contains correct values
            [im, ii_im] = LoadImage('face00001.bmp');
            testCase.verifyEqual(ii_im(2, 2), sum(sum(im(1:2, 1:2))))
        end
        
        function testLoadImage(testCase)
            % Verify that output for face00001.bmp matches debug data
            [im, ii_im] = LoadImage('face00001.bmp');
            dinfo1 = load('DebugInfo/debuginfo1.mat');
            tol = 1e-6;
            testCase.verifyEqual(im(:), dinfo1.im(:), 'AbsTol', tol);
            testCase.verifyEqual(ii_im(:), dinfo1.ii_im(:), 'AbsTol', tol);
        end
        
        %% Test feature computation
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
        
        function testFeatureTypeI(testCase)
            % Verify that features of type I are calculated correctly
            [im, ii_im] = LoadImage('face00001.bmp');
            tol = 1e-6;
            x = 4; y = 6; w = 3; h = 5;
            expected = sum(sum(im(y:y+h-1, x:x+w-1))) ...
                       - sum(sum(im(y+h:y+2*h-1, x:x+w-1)));
            actual = FeatureTypeI(ii_im, x, y, w, h);
            testCase.verifyEqual(actual, expected, 'AbsTol', tol);
        end
        
        function testFeatureTypeII(testCase)
            % Verify that features of type II are calculated correctly
            [im, ii_im] = LoadImage('face00001.bmp');
            tol = 1e-6;
            x = 4; y = 6; w = 3; h = 5;
            expected = sum(sum(im(y:y+h-1, x+w:x+2*w-1))) ...
                       - sum(sum(im(y:y+h-1, x:x+w-1)));
            actual = FeatureTypeII(ii_im, x, y, w, h);
            testCase.verifyEqual(actual, expected, 'AbsTol', tol);
        end
        
        function testFeatureTypeIII(testCase)
            % Verify that features of type III are calculated correctly
            [im, ii_im] = LoadImage('face00001.bmp');
            tol = 1e-6;
            x = 4; y = 6; w = 3; h = 5;
            expected = sum(sum(im(y:y+h-1, x+w:x+2*w-1))) ...
                       - sum(sum(im(y:y+h-1, x:x+w-1))) ...
                       - sum(sum(im(y:y+h-1, x+2*w:x+3*w-1)));
            actual = FeatureTypeIII(ii_im, x, y, w, h);
            testCase.verifyEqual(actual, expected, 'AbsTol', tol);
        end
        
        function testFeatureTypeIV(testCase)
            % Verify that features of type IV are calculated correctly
            [im, ii_im] = LoadImage('face00001.bmp');
            tol = 1e-6;
            x = 4; y = 6; w = 3; h = 5;
            expected = sum(sum(im(y:y+h-1, x+w:x+2*w-1))) ...
                       + sum(sum(im(y+h:y+2*h-1, x:x+w-1))) ...
                       - sum(sum(im(y:y+h-1, x:x+w-1))) ...
                       - sum(sum(im(y+h:y+2*h-1, x+w:x+2*w-1)));
            actual = FeatureTypeIV(ii_im, x, y, w, h);
            testCase.verifyEqual(actual, expected, 'AbsTol', tol);
        end
        
        function testFeatureTypes(testCase)
            % Verify that all calculated features types matches debug data
            [~, ii_im] = LoadImage('face00001.bmp');
            dinfo2 = load('DebugInfo/debuginfo2.mat');
            x = dinfo2.x; y = dinfo2.y; w = dinfo2.w; h = dinfo2.h;
            tol = 1e-6;
            testCase.verifyEqual(FeatureTypeI(ii_im, x, y, w, h), ...
                dinfo2.f1, 'AbsTol', tol);
            testCase.verifyEqual(FeatureTypeII(ii_im, x, y, w, h), ...
                dinfo2.f2, 'AbsTol', tol);
            testCase.verifyEqual(FeatureTypeIII(ii_im, x, y, w, h), ...
                dinfo2.f3, 'AbsTol', tol);
            testCase.verifyEqual(FeatureTypeIV(ii_im, x, y, w, h), ...
                dinfo2.f4, 'AbsTol', tol);
        end
        
        function testEnumAllFeatures(testCase)
            % Verify that the generated list of possible features is sane
            all_ftypes = EnumAllFeatures(19, 19);
            testCase.verifyEqual(size(all_ftypes, 1), 32746);
            for i=1:size(all_ftypes, 1)
                x = all_ftypes(i, 2); y = all_ftypes(i, 3);
                w = all_ftypes(i, 4); h = all_ftypes(i, 5);
                testCase.verifyLessThanOrEqual(x+w-1, 19);
                testCase.verifyLessThanOrEqual(y+h-1, 19);
            end
        end
        
        function testComputeFeature(testCase)
            % Verify that features for a list of images matches debug data
            ii_ims = cell(100, 1);
            for i=1:100
                fname = sprintf('face00%03d.bmp', i);
                [~, ii_im] = LoadImage(fname);
                ii_ims(i) = {ii_im};
            end
            dinfo3 = load('DebugInfo/debuginfo3.mat');
            ftype = dinfo3.ftype;
            tol = 1e-6;
            testCase.verifyEqual(ComputeFeature(ii_ims, ftype), ...
                dinfo3.fs, 'AbsTol', tol);
        end
        
        %% Test vectorized feature computation
        function testVecBoxSum(testCase)
            [~, ii_im] = LoadImage('face00001.bmp');
            inputs = [[1 1 4 6];
                      [1 2 7 2];
                      [2 1 3 9];
                      [2 2 10 10];
                      [3 5 5 5]];
            tol = 1e-6;
            for i = 1:size(inputs, 1)
                x = inputs(i,1); y = inputs(i,2);
                w = inputs(i,3); h = inputs(i,4);
                b_vec = VecBoxSum(x, y, w, h, 19, 19);
                A1 = ii_im(:)' * b_vec;
                A2 = ComputeBoxSum(ii_im, x, y, w, h);
                testCase.verifyEqual(A1, A2, 'AbsTol', tol);
            end
        end
        
        function testVecFeature(testCase)
            [~, ii_im] = LoadImage('face00001.bmp');
            inputs = [[1 1 4 5];
                      [1 2 5 2];
                      [2 1 3 4];
                      [2 2 4 3];
                      [3 5 2 2]];
            tol = 1e-6;
            for i = 1:size(inputs, 1)
                x = inputs(i,1); y = inputs(i,2);
                w = inputs(i,3); h = inputs(i,4);
                ftype_vec1 = VecFeature([1, x, y, w, h], 19, 19);
                ftype_vec2 = VecFeature([2, x, y, w, h], 19, 19);
                ftype_vec3 = VecFeature([3, x, y, w, h], 19, 19);
                ftype_vec4 = VecFeature([4, x, y, w, h], 19, 19);
                actual1 = ii_im(:)' * ftype_vec1;
                actual2 = ii_im(:)' * ftype_vec2;
                actual3 = ii_im(:)' * ftype_vec3;
                actual4 = ii_im(:)' * ftype_vec4;
                expected1 = FeatureTypeI(ii_im, x, y, w, h);
                expected2 = FeatureTypeII(ii_im, x, y, w, h);
                expected3 = FeatureTypeIII(ii_im, x, y, w, h);
                expected4 = FeatureTypeIV(ii_im, x, y, w, h);
                testCase.verifyEqual(actual1, expected1, 'AbsTol', tol);
                testCase.verifyEqual(actual2, expected2, 'AbsTol', tol);
                testCase.verifyEqual(actual3, expected3, 'AbsTol', tol);
                testCase.verifyEqual(actual4, expected4, 'AbsTol', tol);
            end
        end
        
        function testVecComputeFeature(testCase)
            ii_ims = zeros(100, 19*19);
            ii_ims_cell = cell(100, 1);
            for i=1:100
                fname = sprintf('face00%03d.bmp', i);
                [~, ii_im] = LoadImage(fname);
                ii_ims(i,:) = ii_im(:);
                ii_ims_cell(i) = {ii_im};
            end
            tol = 1e-6;
            all_ftypes = [[1 1 1 2 3];
                          [2 1 1 2 3];
                          [3 1 1 2 3];
                          [4 1 1 2 3];
                          [1 2 4 1 1];
                          [2 4 3 2 3];
                          [3 7 6 1 2];
                          [4 1 3 2 3];];
            fmat = VecAllFeatures(all_ftypes, 19, 19);
            for i=1:length(all_ftypes)
                actual = VecComputeFeature(ii_ims, fmat(:, i));
                expected = ComputeFeature(ii_ims_cell, all_ftypes(i, :));
                testCase.assertEqual(actual, expected', 'AbsTol', tol);
            end
        end
        
        %% Test feature extraction
        function testDataExtraction(testCase)
            dinfo4 = load('DebugInfo/debuginfo4.mat');
            ni = dinfo4.ni;
            all_ftypes = dinfo4.all_ftypes;
            im_sfn = 'TestFaceData.mat';
            f_sfn = 'TestFeaturesToMat.mat';
            rng(dinfo4.jseed);
            dirname = 'Pics/TrainingImages/FACES';
            LoadSaveImData(dirname, ni, im_sfn);
            ComputeSaveFData(all_ftypes, f_sfn);
            faceData = load(im_sfn);
            featureData = load(f_sfn);
            tol = 1e-6;
            testCase.verifyEqual(featureData.fmat, dinfo4.fmat, ...
                'AbsTol', tol);
            testCase.verifyEqual(faceData.ii_ims, dinfo4.ii_ims, ...
                'AbsTol', tol);
            delete(im_sfn, f_sfn);
        end
        
        %% Test Adaboost
        function testWeakClassifier(testCase)
            % Verify that the weak classifier learns correctly
            % Load data
            pf_ii_ims = testCase.Fdata.ii_ims;
            nf_ii_ims = testCase.NFdata.ii_ims;
            fmat = testCase.FTdata.fmat;
            ftype_vec = fmat(:, 12028);
            pfs = pf_ii_ims*ftype_vec;
            nfs = nf_ii_ims*ftype_vec;
            n = length(pfs);
            m = length(nfs);
            % Initialize weights
            pws = repmat(1/(2*(n-m)), n, 1);
            nws = repmat(1/(2*m), m, 1);
            % Put together input data
            fs = [pfs; nfs];                    % All feature responses
            ys = [ones(n, 1); zeros(m, 1)];     % Image classifications
            ws = [pws; nws] / sum([pws; nws]);  % Normalized weights
            % Call function and verify results
            [a_theta, a_p, ~] = LearnWeakClassifier(ws, fs, ys);
            tol = 1e-3;
            testCase.assertEqual(a_theta,  -3.6453, 'AbsTol', tol);
            testCase.assertEqual(a_p,  1, 'AbsTol', tol);
        end
        
        function testBoostingAlg(testCase)
            dinfo6 = load('DebugInfo/debuginfo6.mat');
            T = dinfo6.T;
            % Limit to 1000 integral images
            FT = testCase.FTdata;
            FT.fmat = FT.fmat(:,1:1000);
            % Call fn and verify results to debug data
            Cparams = BoostingAlg(testCase.Fdata, testCase.NFdata, FT, T);
            tol = 1e-6;
            testCase.assertEqual(Cparams.alphas, dinfo6.alphas, ...
                'AbsTol', tol);
            testCase.assertEqual(Cparams.Thetas(:), dinfo6.Thetas(:), ...
                'AbsTol', tol);
        end
    end
    
end

