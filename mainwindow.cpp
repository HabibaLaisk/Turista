#include "mainwindow.h"
#include "searchwidget.h"

MainWindow::MainWindow(QWidget *parent) : QMainWindow(parent)
{
    //Creates the search widget
    SearchWidget *widget = new SearchWidget(this);
    setCentralWidget(widget);

    //Connects the SearchWidget
    connect(widget, &SearchWidget::searchRequested, this, &MainWindow::handleSearch);

}

void MainWindow::handleSearch(const QString &city, const QString &arrive, const QString &depart, const QString &budget)
{
    //Backend logic all for debugging
    qDebug() << "Search requested:";
    qDebug() << "City:" << city;
    qDebug() << "Arrive:" << arrive;
    qDebug() << "Depart:" << depart;
    qDebug() << "Budget:" << budget;
}