//
//  InfoTableViewController.swift
//  Wifi UC
//
//  Created by Nicolás Gebauer on 03-06-16.
//  Copyright © 2016 Nicolás Gebauer. All rights reserved.
//

import UIKit
import Static
import Crashlytics

class InfoTableViewController: UITableViewController {

    // MARK: - Constants

    let mail = "negebauer@uc.cl"
    let site = "http://negebauer.github.io"
    let facebook = "https://www.facebook.com/wifiuc"
    let appsite = "http://wachunei.github.io/wifiuc-facebook-tab/"
    let policy = "http://negebauer.github.io/wifiucpolicy.txt"

    let user = "@negebauer"
    let twitter = "https://twitter.com/negebauer"
//    let github = "https://github.com/negebauer"
    let telegram = "http://telegram.me/negebauer"

    let shareUrl = "https://itunes.apple.com/cl/app/wifi-uc/id1099843623?mt=8"
    let reviewUrl = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1099843623&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"

    // MARK: - Variables

    var dataSource: DataSource?
    var viewTitle = "Wifi UC"

    // MARK: - Outlets

    @IBOutlet weak var barButton: UIBarButtonItem!
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        barButton.isEnabled = false
        barButton.tintColor = .clear
        // setNavigationViewColor()
        navigationItem.title = viewTitle
        setData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setData() {
        //        Value1Cell — This is the default cell. It's a plain UITableViewCell with the .Value1 style.
        //        Value2Cell — Plain UITableViewCell with the .Value2 style.
        //        SubtitleCell — Plain UITableViewCell with the .Subtitle style.
        //        ButtonCell — Plain UITableViewCell with the .Default style. The textLabel's textColor is set to the cell's tintColor
        
        // TODO: Update static data
        dataSource = DataSource(tableView: tableView, sections: [
            Section(header: "Legal", rows: [
                Row(text: "Aplicación no oficial de la PUC"),
                Row(text: "Política de privacidad", selection: {self.goToURL(self.policy)}, accessory: .disclosureIndicator)
                ], footer: "Resumen: Tus datos son guardados en tu celular y usados en el portal"),
            
            Section(header: "Aplicación", rows: [
                Row(text: "Sitio", detailText: "", selection: {self.showActions("Sitio", url: self.appsite)}, accessory: .disclosureIndicator),
                Row(text: "Facebook", detailText: "wifiuc", selection: {self.showActions("Facebook", url: self.facebook)}, accessory: .disclosureIndicator/*, image: R.image.facebook()*/),
                Row(text: "Versión", detailText: version()),
                Row(text: "Compartir", detailText: "Pasa la voz", selection: {self.share(self.shareUrl)}, accessory: .disclosureIndicator),
                Row(text: "Me gusta", detailText: review(), selection: {self.reviewAction()}, accessory: .disclosureIndicator),
                ], footer: "Si te sirve la aplicación no olvides dejar una reseña"),
            
            Section(header: "Autor", rows: [
                Row(text: "Nicolás Gebauer"/*, image: R.image.negebauer()*/),
                Row(text: "Email"/*, image: R.image.mail()*/, detailText: mail, selection: {self.sendEmail(self.mail)}, accessory: .disclosureIndicator),
                Row(text: "Twitter"/*, image: R.image.twitter()*/, detailText: user, selection: {self.goToURL(self.twitter)}, accessory: .disclosureIndicator),
                Row(text: "Telegram"/*, image: R.image.telegram()*/, detailText: user, selection: {self.goToURL(self.telegram)}, accessory: .disclosureIndicator),
                //                Row(text: "Github", image: R.image.github(), detailText: user, selection: {self.goToURL(self.github)}, accessory: .DisclosureIndicator),
//                Row(text: "Página web", detailText: pretty(site), selection: {self.showActions("Página web", url: self.site)}, accessory: .DisclosureIndicator)
                ])
            ])
    }

    // MARK: - Actions

    // MARK: - Functions

    func showActions(_ title: String, url: String) {
        let alert = UIAlertController(title: title, message: url, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Abrir en Safari", style: .default, handler: { _ in self.goToURL(url) }))
        alert.addAction(UIAlertAction(title: "Compartir", style: .default, handler: { _ in self.share(url) }))
        alert.addAction(AlertAction.cancelAction())
        alert.popoverPresentationController?.barButtonItem = barButton
        present(alert, animated: true, completion: nil)
    }
    
    func review() -> String {
        if Settings.instance.reviewVersion == version() {
            return "Gracias por la reseña 👍🏻"
        }
        return "Escribe una reseña 😃"
    }

    func reviewAction() {
        Answers.logCustomEvent(withName: "Review", customAttributes: ["Version": version()])
        Settings.instance.reviewVersion = version()
        goToURL(reviewUrl)
        setData()
    }

    func pretty(_ url: String) -> String {
        var readableurl = url.replacingOccurrences(of: "https://", with: "")
        readableurl = readableurl.replacingOccurrences(of: "http://", with: "")
        return readableurl
    }

    func version() -> String {
        var ver = ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            ver += version
        }
        if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            ver += " (\(build))"
        }
        ver = ver.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return ver != "" ? ver : "?"
    }
    
    func share(_ url: String) {
        //        NSArray *activityItems = [NSArray arrayWithObjects:shareString, shareImage, shareUrl, nil];
        //        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        //        activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        //
        //        [self presentViewController:activityViewController animated:YES completion:nil];
        Answers.logCustomEvent(withName: "Share", customAttributes: ["url": url])
        let shareView = UIActivityViewController(activityItems: [URL(string: url)!], applicationActivities: nil)
        shareView.popoverPresentationController?.barButtonItem = barButton
        present(shareView, animated: true, completion: nil)
    }

    func goToURL(_ url: String) {
        Answers.logCustomEvent(withName: "Open url", customAttributes: ["url": url])
        UIApplication.shared.openURL(URL(string: url)!)
    }

    func sendEmail(_ email: String) {
        Answers.logCustomEvent(withName: "Send email", customAttributes: nil)
        self.goToURL("mailto:\(email)")
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }

}
