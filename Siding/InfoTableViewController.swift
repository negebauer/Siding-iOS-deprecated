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
        barButton.enabled = false
        barButton.tintColor = .clearColor()
        // setNavigationViewColor()
        navigationItem.title = viewTitle
        setData()
    }

    override func viewDidAppear(animated: Bool) {
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
                Row(text: "Política de privacidad", selection: {self.goToURL(self.policy)}, accessory: .DisclosureIndicator)
                ], footer: "Resumen: Tus datos son guardados en tu celular y usados en el portal"),
            
            Section(header: "Aplicación", rows: [
                Row(text: "Sitio", detailText: "", selection: {self.showActions("Sitio", url: self.appsite)}, accessory: .DisclosureIndicator),
                Row(text: "Facebook", detailText: "wifiuc", selection: {self.showActions("Facebook", url: self.facebook)}, accessory: .DisclosureIndicator/*, image: R.image.facebook()*/),
                Row(text: "Versión", detailText: version()),
                Row(text: "Compartir", detailText: "Pasa la voz", selection: {self.share(self.shareUrl)}, accessory: .DisclosureIndicator),
                Row(text: "Me gusta", detailText: review(), selection: {self.reviewAction()}, accessory: .DisclosureIndicator),
                ], footer: "Si te sirve la aplicación no olvides dejar una reseña"),
            
            Section(header: "Autor", rows: [
                Row(text: "Nicolás Gebauer"/*, image: R.image.negebauer()*/),
                Row(text: "Email"/*, image: R.image.mail()*/, detailText: mail, selection: {self.sendEmail(self.mail)}, accessory: .DisclosureIndicator),
                Row(text: "Twitter"/*, image: R.image.twitter()*/, detailText: user, selection: {self.goToURL(self.twitter)}, accessory: .DisclosureIndicator),
                Row(text: "Telegram"/*, image: R.image.telegram()*/, detailText: user, selection: {self.goToURL(self.telegram)}, accessory: .DisclosureIndicator),
                //                Row(text: "Github", image: R.image.github(), detailText: user, selection: {self.goToURL(self.github)}, accessory: .DisclosureIndicator),
//                Row(text: "Página web", detailText: pretty(site), selection: {self.showActions("Página web", url: self.site)}, accessory: .DisclosureIndicator)
                ])
            ])
    }

    // MARK: - Actions

    // MARK: - Functions

    func showActions(title: String, url: String) {
        let alert = UIAlertController(title: title, message: url, preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "Abrir en Safari", style: .Default, handler: { _ in self.goToURL(url) }))
        alert.addAction(UIAlertAction(title: "Compartir", style: .Default, handler: { _ in self.share(url) }))
        alert.addAction(AlertAction.cancelAction())
        alert.popoverPresentationController?.barButtonItem = barButton
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func review() -> String {
        if Settings.instance.reviewVersion == version() {
            return "Gracias por la reseña 👍🏻"
        }
        return "Escribe una reseña 😃"
    }

    func reviewAction() {
        Answers.logCustomEventWithName("Review", customAttributes: ["Version": version()])
        Settings.instance.reviewVersion = version()
        goToURL(reviewUrl)
        setData()
    }

    func pretty(url: String) -> String {
        var readableurl = url.stringByReplacingOccurrencesOfString("https://", withString: "")
        readableurl = readableurl.stringByReplacingOccurrencesOfString("http://", withString: "")
        return readableurl
    }

    func version() -> String {
        var ver = ""
        if let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
            ver += version
        }
        if let build = NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as? String {
            ver += " (\(build))"
        }
        ver = ver.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        return ver != "" ? ver : "?"
    }
    
    func share(url: String) {
        //        NSArray *activityItems = [NSArray arrayWithObjects:shareString, shareImage, shareUrl, nil];
        //        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        //        activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        //
        //        [self presentViewController:activityViewController animated:YES completion:nil];
        Answers.logCustomEventWithName("Share", customAttributes: ["url": url])
        let shareView = UIActivityViewController(activityItems: [NSURL(string: url)!], applicationActivities: nil)
        shareView.popoverPresentationController?.barButtonItem = barButton
        presentViewController(shareView, animated: true, completion: nil)
    }

    func goToURL(url: String) {
        Answers.logCustomEventWithName("Open url", customAttributes: ["url": url])
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    }

    func sendEmail(email: String) {
        Answers.logCustomEventWithName("Send email", customAttributes: nil)
        self.goToURL("mailto:\(email)")
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }

}
