% script to process SpamAssassin data into .mat 

%% Initialization
clear ; close all; clc

% path to spamassassin dataset:
path = '/home/kevintham/datasets/spamassassin/';

spam = strcat(path, 'spam/.');
spam_2 = strcat(path, 'spam_2/.');
easy_ham = strcat(path, 'easy_ham/.');
easy_ham_2 = strcat(path, 'easy_ham_2/.');
hard_ham = strcat(path, 'hard_ham/.');

dinfo1 = dir(spam)(3:end-1);
dinfo2 = dir(spam_2)(3:end-1);
dinfo3 = dir(easy_ham)(3:end-1);
dinfo4 = dir(easy_ham_2)(3:end-1);
dinfo5 = dir(hard_ham)(3:end-1);

l1 = size(not([dinfo1.isdir]))(2);
l2 = size(not([dinfo2.isdir]))(2);
l3 = size(not([dinfo3.isdir]))(2);
l4 = size(not([dinfo4.isdir]))(2);
l5 = size(not([dinfo5.isdir]))(2);
l_all = l1+l2+l3+l4+l5;

y = cat(1, zeros(l1+l2,1), ones(l3+l4+l5,1));

data_cell = {};

for i = 1:l1
  file = dinfo1(i).name;
  mail = strjoin(textread(strcat(spam(1:end-1),file), '%s'));
  proc_mail = preproc(mail);
  data_cell{i} = proc_mail;
end

for i = 1:l2
  file = dinfo2(i).name;
  mail = strjoin(textread(strcat(spam_2(1:end-1), file),'%s'));
  proc_mail = preproc(mail);
  data_cell{i+l1} = proc_mail;
end

for i = 1:l3
  file = dinfo3(i).name;
  mail = strjoin(textread(strcat(easy_ham(1:end-1), file),'%s'));
  proc_mail = preproc(mail);
  data_cell{i+l1+l2} = proc_mail;
end

for i = 1:l4
  file = dinfo4(i).name;
  mail = strjoin(textread(strcat(easy_ham_2(1:end-1), file),'%s'));
  proc_mail = preproc(mail);
  data_cell{i+l1+l2+l3} = proc_mail;
end

for i = 1:l5
  file = dinfo5(i).name;
  mail = strjoin(textread(strcat(hard_ham(1:end-1), file),'%s'));
  proc_mail = preproc(mail);
  data_cell{i+l1+l2+l3+l4} = proc_mail;
end


% assemble vocab list
split_data = textscan(strjoin(data_cell), '%s'){1,1};
[vlist_full, num, occ] = unique(split_data);
[occurances ind] = hist(occ, 1:max(occ));
use_ind = find(occurances >= 100);
vocabList = vlist_full(use_ind);


  
  