#ifndef SEARCHWIDGET_H
#define SEARCHWIDGET_H
#include <QWidget>
#include <QLineEdit>

class SearchWidget : public QWidget
{
    Q_OBJECT
public:
    explicit SearchWidget(QWidget *parent = nullptr);

signals:
    void searchRequested(const QString &city, const QString &arrifve, const QString &depart, const QString &budget);

protected: void paintEvent(QPaintEvent *event);

private:
    QLineEdit *destination;
    QLineEdit *arrive;
    QLineEdit *depart;
    QLineEdit *budget;
};

#endif // SEARCHWIDGET_H
