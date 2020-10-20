clear all;
close;

n = 100:100:10000;

comps_insert_0_5 = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.02, 1.04, 1.12, 1.08, 1.22, 1.18, 1.08, 1.1, 1.14, 1.0, 1.04, 1.04, 1.02, 1.12, 1.22, 1.2, 1.22, 1.28, 1.26, 1.34, 1.32, 1.14, 1.08, 1.06, 1.08, 1.14, 1.14, 1.14, 1.22, 1.14, 1.2, 1.18, 1.14, 1.2, 1.22, 1.22, 1.06, 1.24, 1.36, 1.2, 1.38, 1.26, 1.26, 1.32, 1.22, 1.18, 1.2, 1.2, 1.12, 1.18, 1.2, 1.1, 1.2, 1.04, 1.06, 1.04, 1.06, 1.08, 1.08, 1.08, 1.16, 1.06, 1.26, 1.1, 1.08, 1.12, 1.12, 1.2, 1.16, 1.1, 1.08, 1.12, 1.14, 1.16, 1.34, 1.16, 1.16, 1.18, 1.18, 1.22, 1.22, 1.14, 1.16, 1.2, 1.18, 1.16, 1.16, 1.2, 1.26, 1.32, 1.28, 1.14, 1.14, 1.32];
comps_insert_0_8 = [1.0, 1.0, 1.0, 1.0, 1.0, 1.02, 1.02, 1.1, 1.14, 1.08, 1.2, 1.34, 1.64, 1.52, 1.66, 1.96, 1.98, 1.78, 1.84, 2.0, 1.68, 1.82, 1.58, 1.72, 1.52, 1.68, 1.86, 1.82, 1.68, 1.88, 1.9, 1.88, 2.02, 1.84, 1.68, 1.96, 1.88, 1.98, 1.8, 1.7, 1.8, 1.86, 1.62, 1.66, 1.94, 1.54, 1.54, 1.58, 1.7, 1.66, 1.66, 1.62, 1.68, 1.7, 1.68, 1.58, 1.92, 1.74, 1.8, 1.7, 2.08, 2.04, 1.7, 1.86, 1.96, 1.94, 1.78, 1.86, 2.14, 1.7, 1.88, 1.96, 2.16, 1.94, 1.94, 2.24, 1.88, 1.94, 1.9, 1.68, 1.76, 1.9, 1.62, 1.72, 1.78, 1.74, 1.72, 1.72, 1.68, 1.7, 1.6, 1.56, 1.64, 1.58, 1.66, 1.68, 1.56, 1.54, 1.6, 1.62];
comps_search_0_5 = [1.0, 1.14, 1.26, 1.36, 1.22, 1.4, 1.18, 1.22, 1.28, 1.32, 1.3, 1.5, 1.4, 1.32, 1.26, 1.32, 1.26, 1.4, 1.32, 1.28, 1.32, 1.48, 1.4, 1.58, 1.34, 1.36, 1.54, 1.36, 1.36, 1.4, 1.36, 1.5, 1.22, 1.36, 1.26, 1.38, 1.36, 1.4, 1.44, 1.28, 1.44, 1.46, 1.42, 1.42, 1.66, 1.32, 1.42, 1.36, 1.46, 1.48, 1.34, 1.38, 1.42, 1.3, 1.38, 1.42, 1.32, 1.32, 1.46, 1.46, 1.36, 1.32, 1.26, 1.28, 1.36, 1.3, 1.38, 1.34, 1.36, 1.42, 1.3, 1.36, 1.42, 1.54, 1.44, 1.42, 1.26, 1.4, 1.44, 1.3, 1.44, 1.38, 1.36, 1.48, 1.34, 1.26, 1.5, 1.4, 1.3, 1.34, 1.26, 1.2, 1.52, 1.28, 1.58, 1.3, 1.54, 1.44, 1.4, 1.52];
comps_search_0_8 = [1.0, 1.14, 1.36, 1.2, 1.36, 1.28, 1.36, 1.32, 1.34, 1.44, 1.4, 1.44, 1.58, 1.52, 1.64, 1.62, 1.88, 1.5, 1.68, 1.5, 1.66, 1.6, 1.6, 1.74, 1.5, 1.36, 1.62, 1.72, 1.8, 1.68, 1.64, 1.68, 1.6, 1.88, 1.96, 1.78, 1.48, 1.66, 1.96, 1.72, 2.0, 1.88, 1.5, 1.86, 1.72, 1.58, 1.36, 1.58, 1.36, 1.42, 1.78, 1.74, 1.88, 1.36, 1.48, 1.52, 1.54, 1.76, 1.62, 1.64, 1.56, 1.7, 1.72, 1.9, 1.72, 2.16, 1.78, 1.88, 1.8, 1.86, 1.58, 1.62, 2.1, 1.54, 1.46, 1.86, 1.82, 1.84, 1.88, 1.6, 1.72, 1.48, 1.66, 1.64, 1.54, 1.6, 1.8, 1.7, 1.66, 1.8, 1.56, 1.44, 1.62, 1.76, 1.84, 1.5, 1.52, 1.62, 1.66, 1.42];
comps_del_0_5 = [2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.02, 2.06, 2.02, 2.14, 2.1, 2.08, 2.0, 2.02, 2.0, 2.0, 2.02, 2.0, 2.04, 2.12, 2.14, 2.16, 2.06, 2.1, 2.16, 2.06, 2.16, 2.06, 2.0, 2.08, 2.04, 2.08, 2.14, 2.08, 2.02, 2.1, 2.06, 2.1, 2.08, 2.12, 2.16, 2.08, 2.12, 2.04, 2.1, 2.2, 2.14, 2.08, 2.1, 2.08, 2.14, 2.08, 2.08, 2.14, 2.08, 2.08, 2.04, 2.0, 2.0, 2.06, 2.04, 2.08, 2.04, 2.04, 2.06, 2.0, 2.04, 2.1, 2.02, 2.1, 2.04, 2.1, 2.08, 2.1, 2.02, 2.04, 2.08, 2.1, 2.1, 2.08, 2.06, 2.02, 2.08, 2.04, 2.08, 2.1, 2.12, 2.08, 2.08, 2.06, 2.1, 2.08, 2.1, 2.08, 2.08, 2.1, 2.06, 2.08, 2.14];
comps_del_0_8 = [2.0, 2.0, 2.0, 2.0, 2.0, 2.02, 2.0, 2.0, 2.04, 2.04, 2.06, 2.2, 2.14, 2.38, 2.24, 2.42, 2.36, 2.38, 2.38, 2.16, 2.3, 2.32, 2.26, 2.22, 2.34, 2.3, 2.2, 2.3, 2.42, 2.44, 2.5, 2.48, 2.4, 2.34, 2.44, 2.42, 2.52, 2.3, 2.36, 2.48, 2.38, 2.3, 2.28, 2.22, 2.34, 2.32, 2.28, 2.18, 2.28, 2.3, 2.2, 2.24, 2.28, 2.3, 2.24, 2.34, 2.24, 2.26, 2.3, 2.34, 2.3, 2.4, 2.44, 2.4, 2.42, 2.4, 2.44, 2.34, 2.42, 2.4, 2.44, 2.42, 2.36, 2.4, 2.48, 2.4, 2.44, 2.32, 2.4, 2.42, 2.34, 2.4, 2.34, 2.48, 2.3, 2.42, 2.2, 2.52, 2.52, 2.26, 2.34, 2.32, 2.2, 2.22, 2.26, 2.26, 2.28, 2.36, 2.4, 2.3];
comps_insert_BST = [7.4, 8.82, 10.26, 10.4, 10.84, 11.31, 11.45, 12.12, 11.85, 12.31, 12.73, 12.42, 12.72, 12.82, 13.17, 13.32, 13.14, 13.37, 13.24, 13.67, 13.72, 13.88, 13.8, 13.7, 13.82, 14.1, 14.45, 14.2, 14.61, 14.28, 14.48, 14.17, 14.2, 14.75, 14.58, 14.25, 14.74, 14.44, 14.47, 14.38, 14.72, 14.95, 14.53, 14.52, 15.02, 15.38, 14.81, 14.93, 14.45, 15.22, 15.26, 15.6, 15.49, 14.88, 15.47, 15.56, 15.56, 14.96, 15.47, 15.41, 15.72, 15.61, 15.04, 15.36, 15.56, 15.87, 15.22, 15.72, 15.94, 16.09, 15.34, 15.41, 15.73, 15.69, 15.84, 16.15, 16.16, 16.47, 16.03, 16.14, 15.89, 16.14, 15.65, 16.04, 16.36, 15.66, 16.4, 16.48, 16.57, 16.16, 16.19, 16.91, 16.95, 16.43, 16.43, 16.52, 15.96, 16.64, 16.32, 16.05];
comps_search_BST = [7.1, 8.08, 9.2, 9.58, 9.66, 10.0, 9.6, 10.66, 10.8, 11.0, 10.98, 11.12, 11.78, 11.16, 11.52, 11.12, 11.9, 11.9, 12.18, 12.02, 12.18, 11.2, 11.82, 12.32, 12.1, 12.38, 13.18, 12.8, 12.9, 13.76, 12.82, 12.84, 12.0, 13.28, 12.94, 13.4, 13.3, 12.76, 12.96, 13.24, 13.42, 13.7, 13.76, 13.9, 13.8, 12.94, 13.68, 13.12, 13.7, 14.14, 13.26, 13.94, 13.74, 13.7, 13.44, 13.68, 13.6, 13.56, 13.62, 13.56, 13.14, 13.28, 13.58, 14.4, 14.24, 14.22, 13.98, 13.98, 14.56, 14.92, 12.92, 13.58, 14.66, 13.76, 14.32, 14.6, 14.54, 15.02, 14.62, 14.56, 14.36, 14.38, 14.1, 14.26, 14.98, 14.4, 14.02, 15.16, 14.48, 14.5, 14.66, 14.92, 14.6, 14.24, 14.52, 15.1, 15.0, 14.66, 14.66, 14.98];
comps_delete_BST = [8.6, 9.36, 9.96, 10.54, 10.72, 11.28, 11.16, 12.76, 11.88, 12.68, 12.66, 13.34, 12.92, 13.04, 12.64, 13.5, 13.26, 14.0, 13.5, 13.22, 13.78, 13.92, 13.86, 13.24, 14.02, 14.48, 13.68, 13.6, 14.9, 13.94, 14.74, 14.42, 14.24, 14.44, 13.9, 14.2, 14.46, 14.58, 14.86, 14.42, 14.44, 14.32, 14.54, 14.26, 15.0, 14.94, 14.92, 15.22, 14.26, 14.9, 15.44, 14.78, 14.82, 15.3, 15.24, 14.76, 15.7, 14.98, 15.18, 15.38, 15.3, 15.28, 15.06, 16.44, 15.8, 15.2, 15.64, 15.16, 16.26, 14.8, 16.32, 15.26, 15.08, 14.92, 15.88, 15.56, 15.9, 15.6, 16.32, 15.76, 15.9, 16.82, 15.92, 16.42, 16.34, 16.46, 15.44, 16.58, 16.4, 16.0, 15.38, 16.94, 15.8, 15.9, 16.5, 16.82, 15.84, 16.38, 17.06, 16.54];

hold on;
plot(n, comps_insert_BST, 'blue');
plot(n, comps_search_BST, 'red');
plot(n, comps_delete_BST, 'green');
title("Binary Search Tree");
xlabel('# of elements');
ylabel('Avg Comparisons');
legend('Insertion', 'Search','Deletion');

figure();
hold on;
plot(n, comps_insert_0_5, 'blue');
plot(n, comps_search_0_5, 'red');
plot(n, comps_del_0_5, 'green');
ylim([0 7]);
title("Linear Hashing Split @ >50% LF and Merge @ <50% LF");
xlabel('# of elements');
ylabel('Avg Comparisons');
legend('Insertion', 'Search','Deletion');

figure();
hold on;
plot(n, comps_insert_0_8, 'blue');
plot(n, comps_search_0_8, 'red');
plot(n, comps_del_0_8, 'green');
ylim([0 7]);
title("Linear Hashing Split @ >80% LF and Merge @ <50% LF");
xlabel('# of elements');
ylabel('Avg Comparisons');
legend('Insertion', 'Search','Deletion');