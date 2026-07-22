#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

class MainWindow : public QMainWindow{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = nullptr);

private slots:
    void handleSearch(const QString &city, const QString &depart, const QString &arrive, const QString &budget);
};

#endif //MAINWINDOW_H
