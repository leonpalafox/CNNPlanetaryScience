function [recall, specificity, accuracy] = calculate_metrics(predictions, labels, class)

%first we make every other nonlabel to be zero
predictions = predictions==class;
labels = labels ==class;
tp = sum(labels & predictions);
tn = sum(~labels & ~predictions); 
fp = sum(xor(labels(labels==1),predictions(labels == 1)));
fn = sum(xor(~labels(labels==0),~predictions(labels == 0)));

recall = tp / (tp + fn);
accuracy = (tp + tn) / (tp+tn+fp+fn);
specificity = tn/(tn+fp);

