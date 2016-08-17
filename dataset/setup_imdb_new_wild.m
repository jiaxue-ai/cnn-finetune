function  imdb = setup_imdb_new_wild(datasetDir, varargin)
opts.seed = 1 ;
opts = vl_argparse(opts, varargin) ;

rng(opts.seed) ;
imdb.imageDir = fullfile(datasetDir);
imdb.train_imageDir = fullfile(datasetDir,'train') ;
imdb.test_imageDir = fullfile(datasetDir,'test') ;

cats = dir(imdb.train_imageDir) ;
cats = cats([cats.isdir] & ~ismember({cats.name}, {'.','..'})) ;
imdb.classes.name = {cats.name} ;
imdb.images.id = [] ;
imdb.sets = {'train', 'val', 'test'} ;
ins_num=[];
% read data from train folder
for c=1:numel(cats)
  dirinfo = dir(fullfile(imdb.train_imageDir, imdb.classes.name{c}));
  dirinfo(~[dirinfo.isdir]) = [];
  dirinfo = dirinfo(3:end)';
  ims = cell(1);
  ins_num = [ins_num length(dirinfo)];
  for K = 1 : length(dirinfo)
    imsi{K} = dir(fullfile(imdb.train_imageDir, imdb.classes.name{c}, dirinfo(K).name,'*.bmp'));
%     if size(imsi{K})>57
%         imsi{K} = imsi{K}(1:57);
%     end
    for M = 1:size(imsi{K})
        imsi{K}(M).name = fullfile(dirinfo(K).name , imsi{K}(M).name);
%         imsi{K}(M).name = [dirinfo(K).name '/' imsi{K}(M).name];
    end
    if K==1
        ims = imsi{1};
    else
        ims = cat(1,ims, imsi{K});
    end
  end
  
  imdb.images.name{c} = cellfun(@(S) fullfile('train',imdb.classes.name{c}, S), ...
    {ims.name}, 'Uniform', 0);
  imdb.images.label{c} = c * ones(1,numel(ims)) ;
  
end
train_size =length(horzcat(imdb.images.name{:}));

ins_num=[];
%read data from test folder
for c=1:numel(cats)
  dirinfo = dir(fullfile(imdb.test_imageDir, imdb.classes.name{c}));
  dirinfo(~[dirinfo.isdir]) = [];
  dirinfo = dirinfo(3:end)';
  ims = cell(1);
  ins_num = [ins_num length(dirinfo)];
  for K = 1 : length(dirinfo)
    imsi{K} = dir(fullfile(imdb.test_imageDir, imdb.classes.name{c}, dirinfo(K).name,'*.jpg'));
%     if size(imsi{K})>57
%         imsi{K} = imsi{K}(1:57);
%     end
    for M = 1:size(imsi{K})
        imsi{K}(M).name = [dirinfo(K).name '/' imsi{K}(M).name];
    end
    if K==1
        ims = imsi{1};
    else
        ims = cat(1,ims, imsi{K});
    end
  end
  
  imdb.images.name{numel(cats)+c} = cellfun(@(S) fullfile('test',imdb.classes.name{c}, S), ...
    {ims.name}, 'Uniform', 0);
  imdb.images.label{numel(cats)+c} = c * ones(1,numel(ims)) ;
  
end

imdb.images.name = horzcat(imdb.images.name{:}) ;
test_size=length(imdb.images.name)-train_size;
imdb.images.label = horzcat(imdb.images.label{:}) ;
%imdb.images.set = horzcat(imdb.images.set{:}) ;
imdb.images.id = 1:numel(imdb.images.name) ;
%imdb.images.name
% imdb.images.set = zeros(1,size(imdb.images.name,2));
imdb.images.set=[ones(1,train_size),3*ones(1,test_size)];
imdb.segments = imdb.images ;
imdb.segments.imageId = imdb.images.id ;
imdb.images.class=imdb.images.label;
%imdb.images.id 
% make this compatible with the OS imdb
imdb.meta.classes = imdb.classes.name ;
imdb.meta.inUse = true(1,numel(imdb.meta.classes)) ;
imdb.segments.difficult = false(1, numel(imdb.segments.id)) ;


% numClass = 11;
% sum_i = 0;
% test_class = [];
% for i=1:numClass
%     num=sum_i+randi([1 ins_num(i)]);
% %     test_class = [test_class sum_i+randi([1 ins_num(i)])];
%     test_class = [test_class num];
%     %test_class = [test_class num+1];
%     sum_i = sum_i + ins_num(i);
% end
% 
% %test_class
% train_class = setdiff(1:sum(ins_num), test_class);
% %train_class
% total_index = 1:size(imdb.images.name,2);
% %total_index
% index_m = reshape(total_index, 57, uint8(size(total_index,2)/57));
% train_m = index_m(:,train_class);
% test_m = index_m(:,test_class);
% 
% train_index = reshape(train_m, 1, size(train_m(:),1));
% test_index = reshape(test_m, 1, size(test_m(:),1));
% 
% imdb.images.set(1, test_index) = 3;
% imdb.images.set(1, train_index) = 1;
% 
% sel_train = find(imdb.images.set == 3);
% imdb.images.set(sel_train(1 : 2 : end)) = 2;

end