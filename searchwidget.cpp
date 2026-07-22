#include "searchwidget.h"
#include <QPaintEvent>
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QLabel>
#include <QPushButton>
#include <QPainter>
#include <QPixmap>


SearchWidget::SearchWidget(QWidget *parent) : QWidget(parent){
    setMinimumSize(900,600);

    auto *mainLayout = new QVBoxLayout(this);
    mainLayout->setAlignment(Qt::AlignCenter);
    mainLayout->setSpacing(15);

    //The making of the title
    auto *title = new QLabel("Discover the trip that fits you");
    title->setStyleSheet("font-size: 28px; color: white;");
    title->setAlignment(Qt::AlignCenter);
    mainLayout->addWidget(title);

    //Making the destination field
    destination = new QLineEdit();
    destination->setPlaceholderText("Destination city (e.g. Austin, TX)");
    mainLayout->addWidget(destination);

    // Arrival making
    arrive = new QLineEdit();
    arrive->setPlaceholderText("Arrive date");
    mainLayout->addWidget(arrive);

    // Departure making
    depart = new QLineEdit();
    depart->setPlaceholderText("Depart date");
    mainLayout->addWidget(depart);

    //Budget making
    budget = new QLineEdit("500");
    budget->setPlaceholderText("Budget (USD)");
    mainLayout->addWidget(budget);

    //Search Button
    auto *searchBtn = new QPushButton("Search");
    mainLayout->addWidget(searchBtn);

    connect(searchBtn, &QPushButton::clicked, this, [this]{
        emit searchRequested(
            destination->text(),
            arrive->text(),
            depart->text(),
            budget->text()
        );
    });

    // Popular destination rows;
    auto *row = new QHBoxLayout();
    QStringList cities = {
        "Austin, TX", "New York, NY", "New Orleans, LA", "Seattle, WA"
    };

    for(const QString &city : cities) {
        auto *btn = new QPushButton(city);
        connect(btn, &QPushButton::clicked, this, [this, city]{
            destination->setText(city);
        });
        row->addWidget(btn);
    }
    mainLayout->addLayout(row);
}

void SearchWidget::paintEvent(QPaintEvent *event)
{
    QPainter p(this);
    QPixmap bg(":/images/city_background.jpg");

    //Background image
    p.drawPixmap(rect(), bg);
    p.fillRect(rect(),QColor(0,0,0,120));
}