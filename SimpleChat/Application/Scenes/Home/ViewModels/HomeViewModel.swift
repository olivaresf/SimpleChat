//
//  HomeViewModel.swift
//  SimpleChat
//
//  Created by Erik Lopez on 2021/02/09.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func didSelectContact(_ contact: Contact)
}

final class HomeViewModel {
    
    let title = NSLocalizedString("common.appTitle", comment: "")
    let isContactsPermissionGranted = Observable<PermissionState>()
    let isContactsCountUpdated = Observable<Int>()
    
    weak var delegate: HomeViewModelDelegate?
    
    private let contactsPermissionRequester: PermissionRequestable
    private let addressBook: AddressBookProvider
    private var items: [ContactCellViewModel] = []
    
    init(contactsPermissionRequester: PermissionRequestable, addressBook: AddressBookProvider) {
        self.contactsPermissionRequester = contactsPermissionRequester
        self.addressBook = addressBook
        isContactsPermissionGranted.value = contactsPermissionRequester.isPermissionGranted
    }
    
    func requestContactsPermission() {
        contactsPermissionRequester.requestPermission(completionHandler: { [weak self] isGranted, _ in
            self?.isContactsPermissionGranted.value = PermissionState(userResponse: isGranted)
        })
    }
    
    func getContacts() {
        addressBook.getContacts { [weak self] contacts in
            self?.items = contacts.map { ContactCellViewModel($0) }
            self?.isContactsCountUpdated.value = contacts.count
        }
    }
    
    func getNumberOfItems(in section: Int) -> Int {
        return items.count
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> ContactCellViewModel {
        return items[indexPath.item]
    }
    
    func selectItem(at indexPath: IndexPath) {
        let item = items[indexPath.item]
        delegate?.didSelectContact(item.asContact())
    }
    
    func getRequestBackgroundViewModel() -> BackgroundViewViewModel {
        return BackgroundViewViewModel(title: NSLocalizedString("Allow access to your Contacts", comment: ""),
                                   subtitle: NSLocalizedString("Tap here to allow access to your contacts to continue chatting.", comment: ""))
    }
    
    func getBackgroundViewModel() -> BackgroundViewViewModel {
        return BackgroundViewViewModel(title: NSLocalizedString("home.contacts.accessNotAllowed.title", comment: ""),
                                   subtitle: NSLocalizedString("home.contacts.accessNotAllowed.description", comment: ""))
    }
}
