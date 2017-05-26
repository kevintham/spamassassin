% script to process SpamAssassin data into .mat 

%% Initialization
clear ; close all; clc

% path to spamassassin dataset:
path = '/home/kevintham/datasets/spamassassin/';

spam = strcat(path, 'spam/');
spam_2 = strcat(path, 'spam_2/');
easy_ham = strcat(path, 'easy_ham/');
easy_ham_2 = strcat(path, 'easy_ham_2/');
hard_ham = strcat(path, 'hard_ham/');

folders = {spam, spam_2, easy_ham, easy_ham_2, hard_ham};
lengths = [500, 1396, 2500, 1400, 250];
m = sum(lengths);

y = cat(1, zeros(lengths(1)+lengths(2),1), ones(lengths(3)+lengths(4) ...
    +lengths(5),1));

data_cell = {};

for j = 1:5
  dinfo = dir(folders{j})(3:end-1);
  count = 0;
  for i = 1:lengths(j)
    file = dinfo(i).name;
    filepath = strcat(folders{j}, file);
    fprintf('Preprocessing current file: %s \n', filepath);
    if exist('OCTAVE_VERSION')
       fflush(stdout);
    end
    fid = fopen(filepath);
    mail = strjoin(textscan(fid, '%s'){1,1});
    proc_mail = preproc(mail);
    data_cell{i + count} = proc_mail;
  end
  count = count + lengths(j);
end

% assemble vocab list
split_data = textscan(strjoin(data_cell), '%s'){1,1};
[vlist_full, num, occ] = unique(split_data);
[occurances ind] = hist(occ, 1:max(occ));
use_ind = find(occurances >= 100);
vocabList = vlist_full(use_ind);


  
  