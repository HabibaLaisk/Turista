#include <QtTest>
#include <QFile>
#include <QSignalSpy>
#include <QSqlDatabase>
#include <QStandardPaths>

#include "../UserManager.h"
#include "../services/ApiService.h"

class TuristaTests : public QObject
{
    Q_OBJECT

private:
    UserManager *userManager = nullptr;

    QString testDatabasePath() const
    {
        const QString directory =
            QStandardPaths::writableLocation(
                QStandardPaths::AppDataLocation);

        return directory + QStringLiteral("/turista.db");
    }

private slots:
    void initTestCase()
    {
        // Keeps the unit tests separate from the normal app database.
        QStandardPaths::setTestModeEnabled(true);

        if (QFile::exists(testDatabasePath())) {
            QFile::remove(testDatabasePath());
        }

        userManager = new UserManager(this);
    }

    void cleanupTestCase()
    {
        delete userManager;
        userManager = nullptr;

        if (QSqlDatabase::contains()) {
            QSqlDatabase database = QSqlDatabase::database();
            database.close();
        }

        QFile::remove(testDatabasePath());
    }

    // Unit Test #1
    void testNewUsername()
    {
        const bool result = userManager->registerUser(
            QStringLiteral("testuser1"),
            QStringLiteral("Pass123"));

        QVERIFY(result);
    }

    // Unit Test #2
    void testDuplicateUsername()
    {
        const QString username =
            QStringLiteral("duplicateuser");

        QVERIFY(userManager->registerUser(
            username,
            QStringLiteral("Pass123")));

        const bool duplicateResult =
            userManager->registerUser(
                username,
                QStringLiteral("Different456"));

        QVERIFY(!duplicateResult);
    }

    // Unit Test #3
    void testValidLogin()
    {
        const QString username =
            QStringLiteral("validloginuser");

        const QString password =
            QStringLiteral("Correct123");

        QVERIFY(userManager->registerUser(
            username,
            password));

        QVERIFY(userManager->authenticate(
            username,
            password));
    }

    // Unit Test #4
    void testInvalidPassword()
    {
        const QString username =
            QStringLiteral("passworduser");

        QVERIFY(userManager->registerUser(
            username,
            QStringLiteral("Correct123")));

        const bool result =
            userManager->authenticate(
                username,
                QStringLiteral("Wrong123"));

        QVERIFY(!result);
    }

    // Unit Test #5
    void testUnknownUsername()
    {
        const bool result =
            userManager->authenticate(
                QStringLiteral("unknownuser"),
                QStringLiteral("Pass123"));

        QVERIFY(!result);
    }

    // Unit Test #6
    void testEmptyDestination()
    {
        ApiService apiService;

        QSignalSpy failureSpy(
            &apiService,
            &ApiService::searchFailed);

        apiService.search(
            QString(),
            QStringLiteral("2026-09-01"),
            QStringLiteral("2026-09-10"),
            100.0,
            QStringLiteral("All"));

        QCOMPARE(failureSpy.count(), 1);

        const QString message =
            failureSpy.takeFirst().at(0).toString();

        QCOMPARE(
            message,
            QStringLiteral("Please enter a city."));
    }

    // Unit Test #7
    void testInvalidDateFormat()
    {
        ApiService apiService;

        QSignalSpy failureSpy(
            &apiService,
            &ApiService::searchFailed);

        apiService.search(
            QStringLiteral("Austin, TX"),
            QStringLiteral("09/01/2026"),
            QStringLiteral("09/10/2026"),
            100.0,
            QStringLiteral("All"));

        QCOMPARE(failureSpy.count(), 1);

        const QString message =
            failureSpy.takeFirst().at(0).toString();

        QVERIFY(message.contains(
            QStringLiteral("YYYY-MM-DD")));
    }

    // Unit Test #8
    void testDepartureBeforeArrival()
    {
        ApiService apiService;

        QSignalSpy failureSpy(
            &apiService,
            &ApiService::searchFailed);

        apiService.search(
            QStringLiteral("Austin, TX"),
            QStringLiteral("2026-09-10"),
            QStringLiteral("2026-09-01"),
            100.0,
            QStringLiteral("All"));

        QCOMPARE(failureSpy.count(), 1);

        const QString message =
            failureSpy.takeFirst().at(0).toString();

        QCOMPARE(
            message,
            QStringLiteral(
                "The departure date cannot be before the arrival date."));
    }

    // Unit Test #9
    void testMissingApiKeys()
    {
        const bool hadTicketmasterKey =
            qEnvironmentVariableIsSet(
                "TICKETMASTER_API_KEY");

        const bool hadYelpKey =
            qEnvironmentVariableIsSet(
                "YELP_API_KEY");

        const QByteArray savedTicketmasterKey =
            qgetenv("TICKETMASTER_API_KEY");

        const QByteArray savedYelpKey =
            qgetenv("YELP_API_KEY");

        qunsetenv("TICKETMASTER_API_KEY");
        qunsetenv("YELP_API_KEY");

        ApiService apiService;

        QSignalSpy failureSpy(
            &apiService,
            &ApiService::searchFailed);

        apiService.search(
            QStringLiteral("Austin, TX"),
            QStringLiteral("2026-09-01"),
            QStringLiteral("2026-09-10"),
            100.0,
            QStringLiteral("All"));

        QTRY_VERIFY_WITH_TIMEOUT(
            failureSpy.count() > 0,
            5000);

        const QString message =
            failureSpy.takeFirst().at(0).toString();

        // Restore keys before checking the result.
        if (hadTicketmasterKey) {
            qputenv(
                "TICKETMASTER_API_KEY",
                savedTicketmasterKey);
        }

        if (hadYelpKey) {
            qputenv(
                "YELP_API_KEY",
                savedYelpKey);
        }

        QVERIFY(message.contains(
            QStringLiteral("API key is missing"),
            Qt::CaseInsensitive));
    }

    // Unit Test #10
    void testLiveApiConnection()
    {
        if (!qEnvironmentVariableIsSet(
                "TICKETMASTER_API_KEY")
            || !qEnvironmentVariableIsSet(
                "YELP_API_KEY")) {
            QSKIP(
                "API keys are not configured for the test target.");
        }

        ApiService apiService;

        QSignalSpy resultsSpy(
            &apiService,
            &ApiService::resultsReady);

        QSignalSpy failureSpy(
            &apiService,
            &ApiService::searchFailed);

        apiService.search(
            QStringLiteral("Austin, TX"),
            QStringLiteral("2026-09-01"),
            QStringLiteral("2026-12-31"),
            0.0,
            QStringLiteral("All"));

        QTRY_VERIFY_WITH_TIMEOUT(
            resultsSpy.count() > 0
                || failureSpy.count() > 0,
            30000);

        if (failureSpy.count() > 0) {
            const QString errorMessage =
                failureSpy.takeFirst().at(0).toString();

            QFAIL(qPrintable(
                QStringLiteral(
                    "Live API search failed: %1")
                    .arg(errorMessage)));
        }

        QCOMPARE(resultsSpy.count(), 1);

        const QVariantList results =
            resultsSpy.takeFirst().at(0).toList();

        QVERIFY(!results.isEmpty());

        const QVariantMap firstResult =
            results.first().toMap();

        QVERIFY(!firstResult.value(
                                QStringLiteral("title")).toString().isEmpty());

        QVERIFY(!firstResult.value(
                                QStringLiteral("source")).toString().isEmpty());
    }
};

QTEST_MAIN(TuristaTests)

#include "tst_Turista.moc"